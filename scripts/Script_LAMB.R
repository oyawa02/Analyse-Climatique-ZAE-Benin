# ===================================================================
# SCRIPT R : INDICES D'ANOMALIES NORMALISÉES DE LAMB (1991 - 2024)
# Données : climat_77_communes_benin_1991_2024_corrigees.xlsx
# ===================================================================

rm(list = ls(all = TRUE))

library(ggplot2)
library(dplyr)
library(readxl)
library(patchwork)
library(scales)

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
      panel.border     = element_rect(color = "black", fill = NA, linewidth = 0.7)
    )
}

file_excel <- "climat_77_communes_benin_1991_2024_corrigees.xlsx"
donnees_raw <- read_excel(file_excel, sheet = 1)

donnees_propres <- donnees_raw %>%
  mutate(
    Annee = as.numeric(Annee),
    ZAE   = ifelse(grepl("^ZAE", ZAE), ZAE, paste("ZAE", ZAE))
  ) %>%
  filter(Annee >= 1991 & Annee <= 2024)

donnees_mensuelles <- donnees_propres %>%
  group_by(ZAE, Annee, Mois) %>%
  summarise(
    Pluie_mensuelle = mean(as.numeric(Pluie), na.rm = TRUE),
    Tmoy_mensuelle  = mean(as.numeric(Tmoy), na.rm = TRUE),
    .groups = 'drop'
  )

donnees_annuelles <- donnees_mensuelles %>%
  group_by(ZAE, Annee) %>%
  summarise(
    Pluie_annuelle = sum(Pluie_mensuelle, na.rm = TRUE),
    Tmoy_annuelle  = mean(Tmoy_mensuelle, na.rm = TRUE),
    .groups = 'drop'
  )

donnees_lamb <- donnees_annuelles %>%
  group_by(ZAE) %>%
  mutate(
    Pluie_mean = mean(Pluie_annuelle, na.rm = TRUE),
    Pluie_sd   = sd(Pluie_annuelle, na.rm = TRUE),
    Lamb_Pluie = (Pluie_annuelle - Pluie_mean) / Pluie_sd,
    
    Tmoy_mean  = mean(Tmoy_annuelle, na.rm = TRUE),
    Tmoy_sd    = sd(Tmoy_annuelle, na.rm = TRUE),
    Lamb_Tmoy  = (Tmoy_annuelle - Tmoy_mean) / Tmoy_sd
  ) %>%
  ungroup()

creer_graph_lamb <- function(data, zae_nom, variable_lamb, type_var, letter_tag) {
  df_sub <- data %>% 
    filter(ZAE == zae_nom) %>%
    mutate(
      Valeur_Lamb = .data[[variable_lamb]],
      Statut = ifelse(Valeur_Lamb >= 0, "Positif", "Négatif")
    )
  
  if (type_var == "Pluie") {
    col_pos <- "#0072B2"; col_neg <- "#D55E00"; y_title <- "Indice de Lamb (Pluie)"
  } else {
    col_pos <- "#E31A1C"; col_neg <- "#1F78B4"; y_title <- "Indice de Lamb (Tmoy)"
  }
  
  ggplot(df_sub, aes(x = Annee, y = Valeur_Lamb, fill = Statut)) +
    geom_bar(stat = "identity", width = 0.7, color = "black", linewidth = 0.3) +
    geom_hline(yintercept = 0, color = "black", linewidth = 0.7) +
    geom_hline(yintercept = c(-1, 1), linetype = "dashed", color = "gray50", linewidth = 0.5) +
    scale_fill_manual(values = c("Positif" = col_pos, "Négatif" = col_neg)) +
    scale_x_continuous(limits = c(1990.2, 2024.8), breaks = c(1991, 1995, 2000,2005, 2010, 2015, 2020, 2024)) +
    scale_y_continuous(limits = c(-3.2, 3.2), breaks = seq(-3, 3, 1)) +
    labs(y = y_title, x = "Années", title = zae_nom, tag = paste0("(", letter_tag, ")")) +
    publication_style_final() +
    theme(axis.text.x = element_text(size = 7.5, face = "bold", angle = 30, hjust = 1))
}

zae_list <- paste("ZAE", 1:8)
tags     <- letters[1:8]

# Pluie
plots_pluie <- lapply(1:8, function(i) creer_graph_lamb(donnees_lamb, zae_list[i], "Lamb_Pluie", "Pluie", tags[i]))
plan_lamb_pluie <- (plots_pluie[[1]] + plots_pluie[[2]]) / (plots_pluie[[3]] + plots_pluie[[4]]) / 
  (plots_pluie[[5]] + plots_pluie[[6]]) / (plots_pluie[[7]] + plots_pluie[[8]]) +
  plot_annotation(title = "Indice d'Anomalie Normalisée de Lamb - Pluviométrie (1991-2024)",
                  theme = theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 13)))
ggsave("Indice_Lamb_Pluviometrie_8ZAE.png", plot = plan_lamb_pluie, width = 8.5, height = 11.5, units = "in", dpi = 300)

# Température
plots_tmoy <- lapply(1:8, function(i) creer_graph_lamb(donnees_lamb, zae_list[i], "Lamb_Tmoy", "Tmoy", tags[i]))
plan_lamb_tmoy <- (plots_tmoy[[1]] + plots_tmoy[[2]]) / (plots_tmoy[[3]] + plots_tmoy[[4]]) / 
  (plots_tmoy[[5]] + plots_tmoy[[6]]) / (plots_tmoy[[7]] + plots_tmoy[[8]]) +
  plot_annotation(title = "Indice d'Anomalie Normalisée de Lamb - Température Moyenne (1991-2024)",
                  theme = theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 13)))
ggsave("Indice_Lamb_Temperature_Moyenne_8ZAE.png", plot = plan_lamb_tmoy, width = 8.5, height = 11.5, units = "in", dpi = 300)