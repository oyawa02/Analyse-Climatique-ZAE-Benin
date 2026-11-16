# ===================================================================
# SCRIPT R : BILAN CLIMATIQUE MENSUEL MOYEN (BC = P - ETP) (1991 - 2024)
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

mois_labels_3 <- c("Jan", "Fév", "Mar", "Avr", "Mai", "Jun", 
                   "Jul", "Aoû", "Sep", "Oct", "Nov", "Déc")

donnees_propres <- donnees_raw %>%
  mutate(
    Annee    = as.numeric(Annee),
    Mois_Num = as.numeric(Mois),
    Mois     = factor(Mois_Num, levels = 1:12, labels = mois_labels_3),
    ZAE      = ifelse(grepl("^ZAE", ZAE), ZAE, paste("ZAE", ZAE))
  ) %>%
  filter(Annee >= 1991 & Annee <= 2024)

donnees_bc_mensuel <- donnees_propres %>%
  mutate(BC = as.numeric(Pluie) - as.numeric(ETP)) %>%
  group_by(ZAE, Mois) %>%
  summarise(BC_moyen = mean(BC, na.rm = TRUE), .groups = 'drop') %>%
  mutate(Statut = ifelse(BC_moyen >= 0, "Excédent (BC > 0)", "Déficit (BC < 0)"))

creer_graph_bc <- function(data, zae_nom, letter_tag) {
  df_sub <- data %>% filter(ZAE == zae_nom)
  
  ggplot(df_sub, aes(x = Mois, y = BC_moyen, fill = Statut)) +
    geom_bar(stat = "identity", width = 0.7, color = "black", linewidth = 0.3) +
    geom_hline(yintercept = 0, color = "black", linewidth = 0.7) +
    scale_fill_manual(values = c("Excédent (BC > 0)" = "#0072B2", "Déficit (BC < 0)" = "#D55E00")) +
    scale_y_continuous(labels = label_number(accuracy = 1)) +
    labs(y = "BC = P - ETP (mm)", x = "Mois", title = zae_nom, tag = paste0("(", letter_tag, ")")) +
    publication_style_final() +
    theme(axis.text.x = element_text(size = 7.5, face = "bold", angle = 45, hjust = 1))
}

zae_list <- paste("ZAE", 1:8)
tags     <- letters[1:8]

plots_bc <- lapply(1:8, function(i) creer_graph_bc(donnees_bc_mensuel, zae_list[i], tags[i]))

plan_bc_complet <- (plots_bc[[1]] + plots_bc[[2]]) / (plots_bc[[3]] + plots_bc[[4]]) / 
  (plots_bc[[5]] + plots_bc[[6]]) / (plots_bc[[7]] + plots_bc[[8]]) +
  plot_annotation(title = "Bilan Climatique Mensuel Moyen (BC = P - ETP) (1991-2024)",
                  theme = theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 13)))

ggsave("Bilan_Climatique_Mensuel_8ZAE.png", plot = plan_bc_complet, width = 8.5, height = 11.5, units = "in", dpi = 300)