# ==============================================================================
# SCRIPT DE CORRECTION ET DE VALIDATION DES BIAIS CLIMATIQUES 
# Méthodes : LOCI (Pluie) +  Quantile Mapping (Autres Variables) + IDW 
# Ozi as OROU YAWA
# ==============================================================================

rm(list=ls(all=TRUE))

# Répertoire de travail
setwd("C:/Users/pc/Desktop/DR ROEL GIZ/Données_update/Données climatiques/Dossier_Correction_Biais")

# Chargement des packages requis
library(tidyverse)
library(sf)
library(gstat)
library(qmap)
library(lubridate)

# Gestion explicite des conflits de namespaces
select <- dplyr::select
filter <- dplyr::filter

# ------------------------------------------------------------------------------
# 0. CRÉATION DES DOSSIERS DE SORTIE
# ------------------------------------------------------------------------------
dir_out <- "Resultats_Correction_Biais"
dir_fig <- file.path(dir_out, "Figures_Diagnostic")

if (!dir.exists(dir_out)) dir.create(dir_out, recursive = TRUE)
if (!dir.exists(dir_fig)) dir.create(dir_fig, recursive = TRUE)

cat("--> Dossiers de sortie prêts.\n")

# ------------------------------------------------------------------------------
# 1. CHARGEMENT ET NETTOYAGE DES DONNÉES
# ------------------------------------------------------------------------------
cat("--> Chargement et préparation des données...\n")
df_stations_raw <- read.csv("Stations_Benin_7_Variables_Format_GEE_with_coords.csv")
df_communes     <- read.csv("climat_77_communes_benin_1991_2024_coords_corriges.csv")

# Exclusion de NATITINGOU_PEPORIYAKOU (Natitingou synoptique seule)
df_stations <- df_stations_raw %>%
  dplyr::filter(Station != "NATITINGOU_PEPORIYAKOU")

annee_debut <- 1991
annee_fin   <- 2023

coords_stations <- df_stations %>%
  dplyr::select(Station, Longitude, Latitude) %>%
  dplyr::distinct(Station, .keep_all = TRUE)

coords_communes <- df_communes %>%
  dplyr::select(Commune, ZAE, Longitude, Latitude) %>%
  dplyr::distinct(Commune, .keep_all = TRUE)

# ------------------------------------------------------------------------------
# 2. PAIRAGE SPATIAL STATIONS <-> SATELLITES
# ------------------------------------------------------------------------------
st_sf <- st_as_sf(coords_stations, coords = c("Longitude", "Latitude"), crs = 4326)
cm_sf <- st_as_sf(coords_communes, coords = c("Longitude", "Latitude"), crs = 4326)

nearest_idx <- st_nearest_feature(st_sf, cm_sf)
coords_stations$Commune_Match <- coords_communes$Commune[nearest_idx]

df_pairs <- df_stations %>%
  dplyr::filter(Annee >= annee_debut & Annee <= annee_fin) %>%
  dplyr::inner_join(coords_stations %>% dplyr::select(Station, Commune_Match), by = "Station") %>%
  dplyr::inner_join(
    df_communes %>% dplyr::filter(Annee >= annee_debut & Annee <= annee_fin),
    by = c("Commune_Match" = "Commune", "Annee" = "Annee", "Mois" = "Mois"),
    suffix = c("_Obs", "_Sat")
  )

# ------------------------------------------------------------------------------
# 3. CORRECTION DE BIAIS PAR STATIONS (LOCI pour Pluie, QUANTILE MAPPING pour le reste)
# ------------------------------------------------------------------------------
cat("--> Calibration du Quantile Mapping (qmap) & LOCI aux stations...\n")

# A. Calibration LOCI pour la Pluie
loci_factors <- df_pairs %>%
  dplyr::group_by(Station, Longitude_Obs, Latitude_Obs, Mois) %>%
  dplyr::summarise(
    P_threshold_sat = quantile(Pluie_Sat[Pluie_Sat > 0], probs = 0.05, na.rm = TRUE),
    mean_obs = mean(Pluie_Obs, na.rm = TRUE),
    mean_sat_clean = mean(ifelse(Pluie_Sat >= P_threshold_sat, Pluie_Sat, 0), na.rm = TRUE),
    scale_factor = ifelse(mean_sat_clean > 0, mean_obs / mean_sat_clean, 1.0),
    .groups = "drop"
  ) %>%
  dplyr::mutate(scale_factor = pmin(pmax(scale_factor, 0.2), 5.0)) %>%
  na.omit()

# B. Quantile Mapping (qmap) par Station et par Mois pour les autres variables
vars_qm <- c("Tmoy", "Tmin", "Tmax", "HR", "Vent", "ETP")

# Fonction pour appliquer le Quantile Mapping mensuel aux stations
apply_qm_stations <- function(df_pairs, var_name) {
  col_obs <- paste0(var_name, "_Obs")
  col_sat <- paste0(var_name, "_Sat")
  
  df_pairs %>%
    dplyr::group_by(Station, Longitude_Obs, Latitude_Obs, Mois) %>%
    dplyr::group_modify(~ {
      obs_vec <- .x[[col_obs]]
      sat_vec <- .x[[col_sat]]
      
      # Ajustement du Quantile Mapping Empirique
      qm_fit <- fitQmapQUANT(obs_vec, sat_vec, qstep = 0.01, wet.day = FALSE)
      sat_corr <- doQmapQUANT(sat_vec, qm_fit)
      
      # Calcul du delta/offset de la série corrigée par QM
      delta_qm <- mean(sat_corr - sat_vec, na.rm = TRUE)
      
      data.frame(bias_qm_delta = delta_qm)
    }) %>%
    dplyr::ungroup()
}

qm_tmoy <- apply_qm_stations(df_pairs, "Tmoy")
qm_tmin <- apply_qm_stations(df_pairs, "Tmin")
qm_tmax <- apply_qm_stations(df_pairs, "Tmax")
qm_hr   <- apply_qm_stations(df_pairs, "HR")
qm_vent <- apply_qm_stations(df_pairs, "Vent")
qm_etp  <- apply_qm_stations(df_pairs, "ETP")

# ------------------------------------------------------------------------------
# 4. INTERPOLATION IDW DES COEFFICIENTS / DELTAS QM VERS LES 77 COMMUNES
# ------------------------------------------------------------------------------
cat("--> Interpolation spatiale IDW des paramètres corrigés vers les 77 communes...\n")

grid_communes <- st_as_sf(coords_communes, coords = c("Longitude", "Latitude"), crs = 4326)

interpolated_corrections <- expand.grid(
  Commune = coords_communes$Commune,
  Mois = 1:12,
  stringsAsFactors = FALSE
) %>%
  dplyr::left_join(coords_communes %>% dplyr::select(Commune, Longitude, Latitude), by = "Commune")

interpolate_param <- function(df_param, value_col) {
  results <- list()
  for (m in 1:12) {
    df_m <- df_param %>% 
      dplyr::filter(Mois == m) %>% 
      dplyr::filter(!is.na(.data[[value_col]])) %>%
      dplyr::distinct(Longitude_Obs, Latitude_Obs, .keep_all = TRUE)
    
    sf_m <- st_as_sf(df_m, coords = c("Longitude_Obs", "Latitude_Obs"), crs = 4326)
    idw_mod <- gstat(formula = as.formula(paste(value_col, "~ 1")), data = sf_m, set = list(idp = 2.0))
    idw_pred <- predict(idw_mod, grid_communes, debug.level = 0)
    
    res_df <- data.frame(
      Commune = grid_communes$Commune,
      Mois = m,
      val_interp = idw_pred$var1.pred
    )
    results[[m]] <- res_df
  }
  bind_rows(results)
}

interp_loci_scale <- interpolate_param(loci_factors, "scale_factor") %>% dplyr::rename(scale_Pluie = val_interp)
interp_loci_pth   <- interpolate_param(loci_factors, "P_threshold_sat") %>% dplyr::rename(pth_Pluie = val_interp)

interp_tmoy <- interpolate_param(qm_tmoy, "bias_qm_delta") %>% dplyr::rename(delta_Tmoy = val_interp)
interp_tmin <- interpolate_param(qm_tmin, "bias_qm_delta") %>% dplyr::rename(delta_Tmin = val_interp)
interp_tmax <- interpolate_param(qm_tmax, "bias_qm_delta") %>% dplyr::rename(delta_Tmax = val_interp)
interp_hr   <- interpolate_param(qm_hr,   "bias_qm_delta") %>% dplyr::rename(delta_HR = val_interp)
interp_vent <- interpolate_param(qm_vent, "bias_qm_delta") %>% dplyr::rename(delta_Vent = val_interp)
interp_etp  <- interpolate_param(qm_etp,  "bias_qm_delta") %>% dplyr::rename(delta_ETP = val_interp)

param_grid <- interpolated_corrections %>%
  dplyr::left_join(interp_loci_scale, by = c("Commune", "Mois")) %>%
  dplyr::left_join(interp_loci_pth,   by = c("Commune", "Mois")) %>%
  dplyr::left_join(interp_tmoy,       by = c("Commune", "Mois")) %>%
  dplyr::left_join(interp_tmin,       by = c("Commune", "Mois")) %>%
  dplyr::left_join(interp_tmax,       by = c("Commune", "Mois")) %>%
  dplyr::left_join(interp_hr,         by = c("Commune", "Mois")) %>%
  dplyr::left_join(interp_vent,       by = c("Commune", "Mois")) %>%
  dplyr::left_join(interp_etp,        by = c("Commune", "Mois")) %>%
  dplyr::left_join(coords_communes %>% dplyr::select(Commune, ZAE), by = "Commune")

write.csv(param_grid, file.path(dir_out, "Grille_Coefficients_Bias_LOCI_QM.csv"), row.names = FALSE)

# ------------------------------------------------------------------------------
# 5. APPLICATION DE LA CORRECTION AUX SÉRIES COMMUNALES
# ------------------------------------------------------------------------------
cat("--> Application de la correction Quantile Mapping / LOCI aux communes...\n")

df_communes_corriges <- df_communes %>%
  dplyr::left_join(param_grid %>% dplyr::select(-ZAE), by = c("Commune", "Mois", "Longitude", "Latitude")) %>%
  dplyr::mutate(
    # Pluie (LOCI)
    Pluie_Corrigee = ifelse(Pluie >= pth_Pluie, Pluie * scale_Pluie, 0.0),
    Pluie_Corrigee = round(pmax(Pluie_Corrigee, 0.0), 2),
    
    # Températures (Quantile Mapping)
    Tmoy_Corrigee = round(Tmoy + delta_Tmoy, 2),
    Tmin_Corrigee = round(Tmin + delta_Tmin, 2),
    Tmax_Corrigee = round(Tmax + delta_Tmax, 2),
    
    # Contrôle de cohérence Tmin < Tmax
    Tmax_Corrigee = pmax(Tmax_Corrigee, Tmin_Corrigee + 0.1),
    
    # Humidité, Vent, ETP (Quantile Mapping)
    HR_Corrigee   = round(pmin(pmax(HR + delta_HR, 5.0), 100.0), 2),
    Vent_Corrigee = round(pmax(Vent + delta_Vent, 0.1), 2),
    ETP_Corrigee  = round(pmax(ETP + delta_ETP, 0.1), 2)
  ) %>%
  dplyr::select(
    Commune, ZAE, Annee, Mois, Longitude, Latitude,
    Pluie_Brute = Pluie, Pluie_Corrigee,
    Tmoy_Brute = Tmoy, Tmoy_Corrigee,
    Tmin_Brute = Tmin, Tmin_Corrigee,
    Tmax_Brute = Tmax, Tmax_Corrigee,
    HR_Brute = HR, HR_Corrigee,
    Vent_Brute = Vent, Vent_Corrigee,
    ETP_Brute = ETP, ETP_Corrigee
  )

write.csv(df_communes_corriges, file.path(dir_out, "climat_77_communes_benin_1991_2024_LOCI_QM_corriges.csv"), row.names = FALSE)
