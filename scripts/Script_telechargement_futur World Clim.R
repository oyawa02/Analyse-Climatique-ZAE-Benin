# =================================================================================
# SCRIPT R : PROJECTIONS CMIP6 INDIVIDUELLES PAR MODÈLE (77 COMMUNES DU BÉNIN)
# Modèles : CanESM5, ACCESS-CM2, ACCESS-ESM1-5 (Sans agrégation multi-modèle)
# =================================================================================

rm(list = ls(all = TRUE))
setwd("C:/Users/pc/Desktop/DR ROEL GIZ/Données/Données corriger/Données FUTUR")
# --- 0. CHARGEMENT DES PACKAGES ---
packages_needed <- c("geodata", "terra", "sf", "dplyr", "writexl", "readr")
nouveaux_packages <- packages_needed[!(packages_needed %in% installed.packages()[,"Package"])]
if(length(nouveaux_packages)) install.packages(nouveaux_packages)

library(geodata)
library(terra)
library(sf)
library(dplyr)
library(writexl)
library(readr)

# Structure des dossiers d'exportation
dir_spatial <- "climate_spatial_rasters"
dir_tables  <- "climate_excel_tables"
dir.create(dir_spatial, showWarnings = FALSE, recursive = TRUE)
dir.create(dir_tables, showWarnings = FALSE, recursive = TRUE)

cat("Dossier Rasters SIG :", dir_spatial, "\n")
cat("Dossier Tableaux Excel :", dir_tables, "\n")

# --- 1. BASE DE DONNÉES DES 77 COMMUNES DU BÉNIN ET LEURS ZAE ---
communes_77_df <- data.frame(
  Commune = c(
    'Karimama', 'Malanville', 'Banikoara', 'Kandi', 'Tanguieta', 'Kerou', 'Segbana', 
    'Gogounou', 'Materi', 'Kouande', 'Toucountouna', 'Cobly', 'Kalale', 'Sinende', 
    'Bembereke', 'Pehonco', 'Natitingou', 'Boukombe', 'Nikki', 'Djougou', 'Copargo', 
    'N_Dali', 'Perere', 'Ouake', 'Tchaourou', 'Bassila', 'Parakou', 'Ouesse', 
    'Bante', 'Glazoue', 'Save', 'Savalou', 'Dassa-Zoume', 'Ketou', 'Djidja', 
    'Aplahoue', 'Cove', 'Zangnanado', 'Za-Kpota', 'Bohicon', 'Abomey', 'Agbangnizoun', 
    'Pobe', 'Ouinhi', 'Klouekanme', 'Adja-Ouere', 'Zogbodomey', 'Lalo', 'Ze', 
    'Bonou', 'Djakotomey', 'Toffo', 'Toviklin', 'Sakete', 'Dogbo-Tota', 'Adjohoun', 
    'Allada', 'Lokossa', 'Bopa', 'Ifangni', 'Abomey-Calavi', 'Houeyogbe', 'Akpro-Misserete', 
    'Kpomasse', 'Athieme', 'Dangbo', 'So-Ava', 'Avrankou', 'Tori-Bossito', 'Aguegue', 
    'Adjara', 'Porto-Novo', 'Come', 'Ouidah', 'Grand-Popo', 'Seme-Kpodji', 'Cotonou'
  ),
  ZAE = c(
    'ZAE 1', 'ZAE 1', 'ZAE 2', 'ZAE 2', 'ZAE 4', 'ZAE 2', 'ZAE 2', 
    'ZAE 2', 'ZAE 4', 'ZAE 3', 'ZAE 4', 'ZAE 4', 'ZAE 2', 'ZAE 3', 
    'ZAE 2', 'ZAE 3', 'ZAE 4', 'ZAE 4', 'ZAE 3', 'ZAE 4', 'ZAE 4', 
    'ZAE 3', 'ZAE 2', 'ZAE 4', 'ZAE 5', 'ZAE 5', 'ZAE 3', 'ZAE 5', 
    'ZAE 5', 'ZAE 7', 'ZAE 7', 'ZAE 5', 'ZAE 5', 'ZAE 7', 'ZAE 7', 
    'ZAE 6', 'ZAE 7', 'ZAE 7', 'ZAE 7', 'ZAE 7', 'ZAE 7', 'ZAE 7', 
    'ZAE 8', 'ZAE 7', 'ZAE 6', 'ZAE 8', 'ZAE 7', 'ZAE 6', 'ZAE 6', 
    'ZAE 7', 'ZAE 6', 'ZAE 6', 'ZAE 6', 'ZAE 8', 'ZAE 6', 'ZAE 8', 
    'ZAE 6', 'ZAE 6', 'ZAE 6', 'ZAE 8', 'ZAE 6', 'ZAE 6', 'ZAE 8', 
    'ZAE 6', 'ZAE 8', 'ZAE 8', 'ZAE 8', 'ZAE 8', 'ZAE 6', 'ZAE 8', 
    'ZAE 8', 'ZAE 8', 'ZAE 6', 'ZAE 8', 'ZAE 8', 'ZAE 8', 'ZAE 8'
  ),
  lon = c(
    2.7368947, 3.2688381, 2.4003544, 2.9672207, 1.4437152, 2.0079820, 3.4603859, 
    2.6988482, 1.0356313, 1.7237772, 1.4670499, 0.9090117, 3.3953413, 2.3542126, 
    2.7534653, 2.0342705, 1.4106824, 1.1384741, 3.1953995, 1.8548653, 1.5470536, 
    2.4683401, 2.9902006, 1.4396565, 2.4977574, 1.8585539, 2.5803379, 2.4842702, 
    1.8662849, 2.2288717, 2.5655553, 1.8571642, 2.2690058, 2.6022969, 1.9271205, 
    1.6924246, 2.2879854, 2.3926936, 2.2025316, 2.1022403, 1.9774480, 1.9636435, 
    2.6905680, 2.4771219, 1.8360293, 2.5955502, 2.1819537, 1.9737086, 2.3284657, 
    2.4833702, 1.6965267, 2.1774946, 1.8225497, 2.6493251, 1.7629002, 2.5011893, 
    2.1197816, 1.7353602, 1.9310893, 2.7146288, 2.3237519, 1.8522300, 2.5821100, 
    2.0128216, 1.7241659, 2.4915462, 2.4364754, 2.6383395, 2.1487691, 2.5315395, 
    2.6805034, 2.6115709, 1.9043943, 2.1266736, 1.8408097, 2.6041384, 2.4199501
  ),
  lat = c(
    11.943713, 11.651471, 11.343787, 11.208653, 11.030861, 10.928503, 10.921777, 
    10.778077, 10.786663, 10.429472, 10.530899, 10.469743, 10.367708, 10.273516, 
    10.272576, 10.261362, 10.247410, 10.241360, 9.950669,  9.678161,  9.878521, 
    9.735253,  9.594321,  9.595931,  9.162574,  8.970951,  9.369223,  8.526372, 
    8.338504,  8.182893,  7.998205,  7.871684,  7.700539,  7.439789,  7.437302, 
    7.176008,  7.337050,  7.273599,  7.232565,  7.186751,  7.191636,  7.096289, 
    7.093327,  7.069062,  7.039121,  6.997227,  7.023583,  6.866203,  6.760122, 
    6.871872,  6.866545,  6.852570,  6.897725,  6.778012,  6.778971,  6.709607, 
    6.678939,  6.674273,  6.668486,  6.650064,  6.504770,  6.547331,  6.578509, 
    6.456015,  6.542242,  6.581625,  6.475658,  6.568606,  6.542534,  6.475930, 
    6.493699,  6.487276,  6.429472,  6.380045,  6.328395,  6.401914,  6.373762
  )
)

communes_vect <- vect(communes_77_df, geom = c("lon", "lat"), crs = "EPSG:4326")

cat("Téléchargement des limites administratives du Bénin (GADM)...\n")
benin_vector <- gadm(country = "BEN", level = 0, path = dir_spatial)

# --- 2. DONNÉES CLIMATIQUES HISTORIQUES ---
cat("\n--- 1. Traitement des Rasters Historiques ---\n")

tryCatch({
  prec_h <- crop(mask(worldclim_country("BEN", var = "prec", res = 0.5, path = dir_spatial), benin_vector), benin_vector)
  tmax_h <- crop(mask(worldclim_country("BEN", var = "tmax", res = 0.5, path = dir_spatial), benin_vector), benin_vector)
  tmin_h <- crop(mask(worldclim_country("BEN", var = "tmin", res = 0.5, path = dir_spatial), benin_vector), benin_vector)
  tavg_h <- crop(mask(worldclim_country("BEN", var = "tavg", res = 0.5, path = dir_spatial), benin_vector), benin_vector)
  
  writeRaster(sum(prec_h), file.path(dir_spatial, "Benin_Historique_Pluie_mm.tif"), overwrite = TRUE)
  writeRaster(mean(tavg_h), file.path(dir_spatial, "Benin_Historique_Tmoy_degC.tif"), overwrite = TRUE)
  writeRaster(mean(tmax_h), file.path(dir_spatial, "Benin_Historique_Tmax_degC.tif"), overwrite = TRUE)
  writeRaster(mean(tmin_h), file.path(dir_spatial, "Benin_Historique_Tmin_degC.tif"), overwrite = TRUE)
  
  cat("  Rasters Historiques créés avec succès.\n")
}, error = function(e) {
  cat("  Note Historique :", e$message, "\n")
})

# --- 3. EXTRACTION PAR MODÈLE INDIVIDUEL (CANESM5, ACCESS-CM2, ACCESS-ESM1-5) ---
cat("\n--- 2. Génération des Rasters et Données par Modèle Individuel ---\n")

models     <- c("CanESM5", "ACCESS-CM2", "ACCESS-ESM1-5")
ssps       <- c("126", "245", "370", "585")
ssp_labels <- c("126" = "SSP1-2.6", "245" = "SSP2-4.5", "370" = "SSP3-7.0", "585" = "SSP5-8.5")

periods       <- c("2021-2040", "2041-2060", "2081-2100")
horizon_names <- c("2021-2040" = "2030", "2041-2060" = "2050", "2081-2100" = "2100")

target_res <- 2.5 # ~5 km de résolution spatiale au Bénin

extracted_data_list <- list()
counter <- 1

for (m in models) {
  m_code <- gsub("-", "", m)
  cat(sprintf("\n=========================================================\n"))
  cat(sprintf("TRAITEMENT SPÉCIFIQUE DU MODÈLE : %s\n", m))
  cat(sprintf("=========================================================\n"))
  
  for (ssp in ssps) {
    ssp_lab   <- ssp_labels[ssp]
    ssp_clean <- paste0("ssp", ssp)
    
    for (period in periods) {
      horiz_lab <- horizon_names[period]
      
      cat(sprintf("Extrait : Modèle %s | Scénario %s | Horizon %s ...\n", m, ssp_lab, horiz_lab))
      
      tryCatch({
        # 1. Téléchargement des rasters spécifiques au modèle
        r_tmax <- cmip6_world(model = m, ssp = ssp, time = period, var = "tmax", res = target_res, path = dir_spatial)
        r_tmin <- cmip6_world(model = m, ssp = ssp, time = period, var = "tmin", res = target_res, path = dir_spatial)
        r_prec <- cmip6_world(model = m, ssp = ssp, time = period, var = "prec", res = target_res, path = dir_spatial)
        
        # 2. Découpage et masquage au contour du Bénin
        r_tmax <- crop(mask(r_tmax, benin_vector), benin_vector)
        r_tmin <- crop(mask(r_tmin, benin_vector), benin_vector)
        r_prec <- crop(mask(r_prec, benin_vector), benin_vector)
        
        # 3. Calculs des métriques annuelles
        r_tmax_ann  <- mean(r_tmax)
        r_tmin_ann  <- mean(r_tmin)
        r_tmoy_ann  <- (r_tmax_ann + r_tmin_ann) / 2
        r_pluie_ann <- sum(r_prec)
        
        # 4. Exportation des GeoTIFFs distincts par modèle
        fn_pluie <- sprintf("Benin_Pluie_%s_%s_Horizon_%s.tif", m_code, ssp_clean, horiz_lab)
        fn_tmoy  <- sprintf("Benin_Tmoy_%s_%s_Horizon_%s.tif",  m_code, ssp_clean, horiz_lab)
        fn_tmax  <- sprintf("Benin_Tmax_%s_%s_Horizon_%s.tif",  m_code, ssp_clean, horiz_lab)
        fn_tmin  <- sprintf("Benin_Tmin_%s_%s_Horizon_%s.tif",  m_code, ssp_clean, horiz_lab)
        
        writeRaster(r_pluie_ann, file.path(dir_spatial, fn_pluie), overwrite = TRUE)
        writeRaster(r_tmoy_ann,  file.path(dir_spatial, fn_tmoy),  overwrite = TRUE)
        writeRaster(r_tmax_ann,  file.path(dir_spatial, fn_tmax),  overwrite = TRUE)
        writeRaster(r_tmin_ann,  file.path(dir_spatial, fn_tmin),  overwrite = TRUE)
        
        # 5. Extraction ponctuelle aux 77 communes
        stk <- c(r_tmoy_ann, r_tmax_ann, r_tmin_ann, r_pluie_ann)
        names(stk) <- c("Tmoy_Futur", "Tmax_Futur", "Tmin_Futur", "Pluie_Futur")
        
        vals <- terra::extract(stk, communes_vect, ID = FALSE)
        df_m <- cbind(communes_77_df, vals) %>%
          mutate(
            SSP = ssp_lab,
            Horizon = horiz_lab,
            Modele = m
          )
        
        extracted_data_list[[counter]] <- df_m
        counter <- counter + 1
        
        cat(sprintf("   ✓ Rasters et données extraits avec succès (%s | %s | %s)\n", m, ssp_lab, horiz_lab))
        
      }, error = function(e) {
        cat(sprintf("Erreur sur %s (%s %s) : %s\n", m, ssp_lab, horiz_lab, e$message))
      })
    }
  }
}

# --- 4. EXPORTATION DES CLASSEURS EXCEL ET CSV PAR MODÈLE ---
cat("\n--- 3. Génération des fichiers Excel et CSV ---\n")

if (length(extracted_data_list) > 0) {
  
  df_all_77 <- bind_rows(extracted_data_list) %>%
    mutate(
      Pluie_Futur = round(Pluie_Futur, 1),
      Tmoy_Futur  = round(Tmoy_Futur, 2),
      Tmax_Futur  = round(Tmax_Futur, 2),
      Tmin_Futur  = round(Tmin_Futur, 2)
    )
  
  df_zae_summary <- df_all_77 %>%
    group_by(ZAE, SSP, Horizon, Modele) %>%
    summarise(
      Pluie_Moyenne_mm = round(mean(Pluie_Futur, na.rm = TRUE), 1),
      Tmoy_Moyenne_degC = round(mean(Tmoy_Futur, na.rm = TRUE), 2),
      Tmax_Moyenne_degC = round(mean(Tmax_Futur, na.rm = TRUE), 2),
      Tmin_Moyenne_degC = round(mean(Tmin_Futur, na.rm = TRUE), 2),
      .groups = "drop"
    )
  
  # Exportation CSV Global
  write_csv(df_all_77,      file.path(dir_tables, "Projections_CMIP6_77_Communes_Par_Modele.csv"))
  write_csv(df_zae_summary, file.path(dir_tables, "Projections_CMIP6_ZAE_Par_Modele.csv"))
  
  # Exportation Excel avec un onglet par Modèle
  excel_sheets <- list(
    "CanESM5_Communes"       = df_all_77 %>% filter(Modele == "CanESM5"),
    "ACCESS_CM2_Communes"    = df_all_77 %>% filter(Modele == "ACCESS-CM2"),
    "ACCESS_ESM1_5_Communes" = df_all_77 %>% filter(Modele == "ACCESS-ESM1-5"),
    "Synthese_ZAE_TousModeles" = df_zae_summary
  )
  
  write_xlsx(excel_sheets, path = file.path(dir_tables, "Projections_Climatiques_CMIP6_77_Communes_Par_Modele.xlsx"))
  
  cat("  ✓ Fichier Excel généré : 'climate_excel_tables/Projections_Climatiques_CMIP6_77_Communes_Par_Modele.xlsx'\n")
  cat("  ✓ Fichiers CSV générés dans 'climate_excel_tables/'\n")
}

cat("\n=================================================================================\n")
cat("TOUS LES RASTERS ET TABLEAUX INDIVIDUELS ONT ÉTÉ GÉNÉRÉS AVEC SUCCÈS !\n")
cat("Fichiers GeoTIFF : 'climate_spatial_rasters/'\n")
cat("Fichiers Excel/CSV : 'climate_excel_tables/'\n")
cat("=================================================================================\n")