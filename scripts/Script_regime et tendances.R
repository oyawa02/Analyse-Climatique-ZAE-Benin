# ==============================================================================
# SCRIPT RÉGIME INTERANNUEL ET INTERMENSUEL DES PARAMÈTRES CLIMATIQUES
# PAR ZAE AU BÉNIN (1991 - 2024)
# Auteur : Ozias OROU YAWA
# ==============================================================================

rm(list = ls(all = TRUE))

# Répertoire de travail
setwd("C:/Users/pc/Desktop/DR ROEL GIZ/Données_update/Données climatiques/Dossier_Correction_Biais/Données finale")

# --- PARTIE 0 : Chargement des Packages ---
library(ggplot2)
library(dplyr)
library(readxl)
library(tidyr)
library(ggpubr)
library(patchwork)
library(scales)

# Explicit Namespace
select <- dplyr::select
filter <- dplyr::filter

# --- PARTIE 1 : Définition du Thème Personnalisé pour les Figures ---
publication_style_final <- function() { 
  theme_bw(base_size = 11) +
    theme(
      axis.title       = element_text(size = 9.5, face = "bold", color = "black"),
      plot.title       = element_text(size = 10.5, face = "bold", hjust = 0.5, color = "black"),
      plot.tag         = element_text(size = 11, face = "bold", color = "black"),
      legend.position  = "none",
      panel.grid.major = element_line(color = "grey92", linewidth = 0.4),
      panel.grid.minor = element_blank(),
      axis.text        = element_text(size = 8.5, color = "black"),
      panel.border     = element_rect(color = "black", fill = NA, linewidth = 0.7),
      plot.margin      = margin(4, 4, 4, 4, "pt")
    )
}

# --- PARTIE 2 : Chargement et Structuration du Fichier Excel Propre ---
cat("--> Chargement et structuration du fichier Excel propre...\n")

file_excel <- "climat_77_communes_benin_1991_2024_corrigees.xlsx"

# Chargement de la première feuille du fichier Excel
donnees_raw <- read_excel(file_excel, sheet = 1)

# Noms de mois courts à 3 lettres
mois_labels_3 <- c("Jan", "Fév", "Mar", "Avr", "Mai", "Jun", 
                   "Jul", "Aoû", "Sep", "Oct", "Nov", "Déc")

donnees_propres <- donnees_raw %>%
  mutate(
    Annee    = as.numeric(Annee),
    Mois_Num = as.numeric(Mois),
    Mois     = factor(Mois_Num, levels = 1:12, labels = mois_labels_3),
    ZAE      = ifelse(grepl("^ZAE", ZAE), ZAE, paste("ZAE", ZAE)) # Sécurisation format 'ZAE X'
  ) %>%
  filter(Annee >= 1991 & Annee <= 2024)

# Format long Tidy pour ggplot2
donnees_longues <- donnees_propres %>%
  pivot_longer(
    cols      = c(Pluie, Tmoy, Tmin, Tmax, HR, Vent, ETP),
    names_to  = "Parametre_Code",
    values_to = "Valeur"
  ) %>%
  mutate(
    Valeur = as.numeric(Valeur),
    Parametre_Climatique = case_when(
      Parametre_Code == "Pluie" ~ "Pluie (mm)",
      Parametre_Code == "Tmoy"  ~ "Tmoy (°C)",
      Parametre_Code == "Tmin"  ~ "Tmin (°C)",
      Parametre_Code == "Tmax"  ~ "Tmax (°C)",
      Parametre_Code == "HR"    ~ "Humidité Relative (%)",
      Parametre_Code == "Vent"  ~ "Vitesse du Vent (m/s)",
      Parametre_Code == "ETP"   ~ "Évapotranspiration (mm)"
    )
  )

cat("--> Vérification des paramètres chargés :\n")
print(unique(donnees_longues$Parametre_Climatique))

# --- PARTIE 3 : Agrégations Spatio-Temporelles par ZAE ---
cat("--> Calcul des agrégations mensuelles et annuelles par ZAE...\n")

# 1. Régimes mensuels : Moyenne spatiale des communes par ZAE et par an
donnees_zae_mensuel <- donnees_longues %>%
  group_by(ZAE, Annee, Parametre_Climatique, Mois) %>%
  summarise(
    Valeur = mean(Valeur, na.rm = TRUE),
    .groups = 'drop'
  )

# 2. Tendances annuelles : Cumul (Pluie, ETP) ou Moyenne (Températures, HR, Vent)
donnees_zae_annuel <- donnees_zae_mensuel %>%
  group_by(ZAE, Annee, Parametre_Climatique) %>%
  summarise(
    Valeur_annuelle = if (first(Parametre_Climatique) %in% c("Pluie (mm)", "Évapotranspiration (mm)")) {
      sum(Valeur, na.rm = TRUE)
    } else {
      mean(Valeur, na.rm = TRUE)
    },
    .groups = 'drop'
  )

# --- PARTIE 4 : Fonctions de Tracé des Graphiques ---

# 1. Régimes Mensuels (Boxplot + Courbe moyenne)
creer_graph_regime <- function(data, zae_nom, param_name, color, y_label, letter_tag) {
  df_sub <- data %>% filter(ZAE == zae_nom, Parametre_Climatique == param_name)
  
  ggplot(df_sub, aes(x = Mois, y = Valeur)) +
    geom_boxplot(fill = color, alpha = 0.5, color = "black", outlier.shape = 16, outlier.size = 0.8, linewidth = 0.4) +
    stat_summary(fun = mean, geom = "line", aes(group = 1), color = "black", linewidth = 0.7) +
    stat_summary(fun = mean, geom = "point", shape = 21, size = 1.5, fill = "white", color = "black") +
    scale_y_continuous(labels = label_number(accuracy = 0.1)) +
    labs(y = y_label, x = "Mois", title = zae_nom, tag = paste0("(", letter_tag, ")")) +
    publication_style_final() +
    theme(axis.text.x = element_text(size = 7.5, face = "bold", angle = 45, hjust = 1))
}

# 2. Tendances Annuelles (Régression Linéaire + Équation)
creer_graph_tendance <- function(data, zae_nom, param_name, color, y_label, letter_tag) {
  df_sub <- data %>% filter(ZAE == zae_nom, Parametre_Climatique == param_name, !is.na(Valeur_annuelle))
  
  ggplot(df_sub, aes(x = Annee, y = Valeur_annuelle)) +
    geom_line(color = "gray40", linetype = "dashed", linewidth = 0.5) +
    geom_point(shape = 21, fill = "white", color = "black", size = 1.4, stroke = 0.6) +
    geom_smooth(method = "lm", se = FALSE, color = color, linetype = "solid", linewidth = 0.9) +
    stat_regline_equation(
      label.y.npc = 0.92, label.x.npc = 0.03, 
      aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~~")), 
      size = 2.8
    ) +
    scale_x_continuous(
      limits = c(1991, 2024),
      breaks = c(1991, 1995, 2000,2005, 2010, 2015, 2020, 2024)
    ) +
    scale_y_continuous(labels = label_number(accuracy = 0.1)) +
    labs(y = y_label, x = "Années", title = zae_nom, tag = paste0("(", letter_tag, ")")) +
    publication_style_final() +
    theme(axis.text.x = element_text(size = 7.5, face = "bold", angle = 30, hjust = 1))
}

# --- PARTIE 5 : Génération et Sauvegarde des Planches 4x2 ---

parametres <- unique(donnees_zae_mensuel$Parametre_Climatique)

couleurs_params <- c(
  "Pluie (mm)"               = "#0072B2",
  "Tmoy (°C)"                = "#D55E00",
  "Tmin (°C)"                = "#1F78B4",
  "Tmax (°C)"                = "#E31A1C",
  "Humidité Relative (%)"    = "#009E73",
  "Vitesse du Vent (m/s)"    = "#333333",
  "Évapotranspiration (mm)"  = "#E69F00"
)

cat("--> Génération des figures au format image (300 DPI)...\n")

zae_list <- paste("ZAE", 1:8)
tags     <- letters[1:8]

for (param in parametres) {
  col <- couleurs_params[param]
  cat(paste("    - Génération pour :", param, "\n"))
  
  # --- 1. PLANCHE DES RÉGIMES MENSUELS (8 ZAE) ---
  plots_regime <- lapply(1:8, function(i) {
    creer_graph_regime(donnees_zae_mensuel, zae_list[i], param, col, param, tags[i])
  })
  
  plan_regime_complet <- (plots_regime[[1]] + plots_regime[[2]]) / 
    (plots_regime[[3]] + plots_regime[[4]]) / 
    (plots_regime[[5]] + plots_regime[[6]]) / 
    (plots_regime[[7]] + plots_regime[[8]]) +
    plot_annotation(
      title = paste("Régimes Mensuels (1991-2024) -", param),
      theme = theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 13))
    )
  
  ggsave(
    filename = paste0("Regime_Complet_8ZAE_", gsub("[^A-Za-z0-9]", "_", param), ".png"), 
    plot = plan_regime_complet, width = 8.5, height = 11.5, units = "in", dpi = 300
  )
  
  # --- 2. PLANCHE DES TENDANCES ANNUELLES (8 ZAE) ---
  plots_tendance <- lapply(1:8, function(i) {
    creer_graph_tendance(donnees_zae_annuel, zae_list[i], param, col, paste(param, "(Annuel)"), tags[i])
  })
  
  plan_tendance_complet <- (plots_tendance[[1]] + plots_tendance[[2]]) / 
    (plots_tendance[[3]] + plots_tendance[[4]]) / 
    (plots_tendance[[5]] + plots_tendance[[6]]) / 
    (plots_tendance[[7]] + plots_tendance[[8]]) +
    plot_annotation(
      title = paste("Tendances Annuelles (1991-2024) -", param),
      theme = theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 13))
    )
  
  ggsave(
    filename = paste0("Tendance_Complet_8ZAE_", gsub("[^A-Za-z0-9]", "_", param), ".png"), 
    plot = plan_tendance_complet, width = 8.5, height = 11.5, units = "in", dpi = 300
  )
}

cat("\n========================================================================\n")
cat(" TRAITEMENT ET GÉNÉRATION DES FIGURES TERMINÉS AVEC SUCCÈS !\n")
cat("========================================================================\n")