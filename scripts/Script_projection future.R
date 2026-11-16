# ===================================================================
# PROJECTIONS CLIMATIQUES CMIP6 
# Auteur : Ozias OROU YAWA
# ===================================================================

rm(list = ls(all = TRUE))

# --- 1. PACKAGES REQUIS ---
library(ggplot2)
library(dplyr)
library(readr)
library(tidyr)
library(patchwork)
library(scales)

# --- 2. STYLE GRAPHIQUE POUR PUBLICATION ---
publication_style_final <- function() { 
  theme_bw(base_size = 12) +
    theme(
      axis.title = element_text(size = 10.5, face = "bold", color = "black"),
      plot.title = element_text(size = 11.5, face = "bold", hjust = 0.5, color = "black"),
      plot.tag = element_text(size = 13, face = "bold", color = "black"),
      legend.position = "none",
      panel.grid.major = element_line(color = "grey92"),
      panel.grid.minor = element_blank(),
      axis.text = element_text(size = 9, color = "black"),
      panel.border = element_rect(color = "black", fill = NA, linewidth = 0.8)
    )
}

# --- 3. CHARGEMENT ET PRÉPARATION DES DONNÉES CSV ---
fichier_csv <- "Projections_CMIP6_77_Communes_Par_Modele.csv"

if (!file.exists(fichier_csv)) {
  fichier_csv <- file.path("CMIP6_Benin_Analysis", "Projections_CMIP6_77_Communes_Par_Modele.csv")
}

donnees_proj <- read_csv(fichier_csv, show_col_types = FALSE)

# Formatage des horizons
donnees_proj_clean <- donnees_proj %>%
  mutate(
    Horizon_Court = factor(as.character(Horizon), levels = c("2030", "2050", "2100"))
  )

# --- 4. AGRÉGATION SPATIALE PAR ZAE, MODÈLE, SSP ET HORIZON ---
donnees_zae_modele <- donnees_proj_clean %>%
  group_by(ZAE, Modele, SSP, Horizon_Court) %>%
  summarise(
    Pluie = mean(Pluie_Futur, na.rm = TRUE),
    Tmoy  = mean(Tmoy_Futur, na.rm = TRUE),
    Tmax  = mean(Tmax_Futur, na.rm = TRUE),
    Tmin  = mean(Tmin_Futur, na.rm = TRUE),
    .groups = 'drop'
  )

# Passage au format long
donnees_zae_long <- donnees_zae_modele %>%
  pivot_longer(cols = c(Pluie, Tmoy, Tmax, Tmin), names_to = "Variable", values_to = "Valeur")

# --- 5. PALETTE DE COULEURS POUR LES SCÉNARIOS SSP ---
couleurs_ssp <- c(
  "SSP1-2.6" = "#1B9E77",
  "SSP2-4.5" = "#D95F02",
  "SSP3-7.0" = "#7570B3",
  "SSP5-8.5" = "#E7298A"
)

# Configuration des unités des variables
unites_vars <- c(
  "Pluie" = "Pluie (mm/an)",
  "Tmoy"  = "Tmoy (°C)",
  "Tmax"  = "Tmax (°C)",
  "Tmin"  = "Tmin (°C)"
)

titres_vars <- c(
  "Pluie" = "Pluviométrie",
  "Tmoy"  = "Température Moyenne",
  "Tmax"  = "Température Maximale",
  "Tmin"  = "Température Minimale"
)

# --- 6. FONCTIONS DE TRACÉ ET D'ASSEMBLAGE DES FIGURES ---

creer_graph_projection_horizon <- function(data, zae_nom, var_target, modele_target, y_label, letter_tag) {
  df_sub <- data %>% 
    filter(ZAE == zae_nom, Variable == var_target, Modele == modele_target)
  
  ggplot(df_sub, aes(x = Horizon_Court, y = Valeur, group = SSP, color = SSP)) +
    geom_line(linewidth = 1, alpha = 0.85) +
    geom_point(size = 2.5, shape = 21, fill = "white", stroke = 1.2) +
    scale_color_manual(values = couleurs_ssp, name = "Scénario SSP") +
    scale_y_continuous(labels = label_number(accuracy = 0.1)) +
    labs(y = y_label, x = "Horizons", title = zae_nom, tag = paste0("(", letter_tag, ")")) +
    publication_style_final() +
    theme(
      axis.text.x = element_text(size = 9.5, face = "bold")
    )
}

generer_planche_2x4_horizons <- function(data, var_target, modele_target, filename_out) {
  y_label <- unites_vars[[var_target]]
  titre_var <- titres_vars[[var_target]]
  
  p1 <- creer_graph_projection_horizon(data, "ZAE 1", var_target, modele_target, y_label, "a")
  p2 <- creer_graph_projection_horizon(data, "ZAE 2", var_target, modele_target, y_label, "b")
  p3 <- creer_graph_projection_horizon(data, "ZAE 3", var_target, modele_target, y_label, "c")
  p4 <- creer_graph_projection_horizon(data, "ZAE 4", var_target, modele_target, y_label, "d")
  p5 <- creer_graph_projection_horizon(data, "ZAE 5", var_target, modele_target, y_label, "e")
  p6 <- creer_graph_projection_horizon(data, "ZAE 6", var_target, modele_target, y_label, "f")
  p7 <- creer_graph_projection_horizon(data, "ZAE 7", var_target, modele_target, y_label, "g")
  p8 <- creer_graph_projection_horizon(data, "ZAE 8", var_target, modele_target, y_label, "h")
  
  planche_complete <- (p1 + p2) / 
    (p3 + p4) / 
    (p5 + p6) / 
    (p7 + p8) +
    plot_layout(guides = "collect") & 
    theme(
      legend.position = "bottom",
      legend.title = element_text(size = 10, face = "bold"),
      legend.text  = element_text(size = 9.5, face = "bold")
    )
  
  planche_complete <- planche_complete +
    plot_annotation(
      title = paste0("Projections CMIP6 - ", titre_var, " (Modèle : ", modele_target, ")"),
      subtitle = "Évolution par ZAE selon les scénarios SSP (2030, 2050, 2100)",
      theme = theme(
        plot.title = element_text(hjust = 0.5, face = "bold", size = 13),
        plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 10)
      )
    )
  
  ggsave(filename_out, plot = planche_complete, width = 7.5, height = 10.5, units = "in", dpi = 300)
  cat(paste0("  ✓ Figure enregistrée : '", filename_out, "'\n"))
}

# --- 7. GÉNÉRATION AUTOMATIQUE DES 12 FIGURES ---

modeles_list <- c("ACCESS-CM2", "ACCESS-ESM1-5", "CanESM5")
variables_list <- c("Pluie", "Tmoy", "Tmax", "Tmin")

cat("\n--- Début de la génération des 12 figures ---\n")

for (mod in modeles_list) {
  for (var in variables_list) {
    nom_fichier <- paste0("Projection_", var, "_", gsub("-", "_", mod), "_8ZAE.png")
    generer_planche_2x4_horizons(
      data = donnees_zae_long,
      var_target = var,
      modele_target = mod,
      filename_out = nom_fichier
    )
  }
}

cat("--- Génération terminée avec succès ! ---\n")