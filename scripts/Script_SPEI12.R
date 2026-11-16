# ===================================================================
# SCRIPT R : INDICE SPEI-12 DE SÉCHERESSE (1991 - 2024)
# Données : climat_77_communes_benin_1991_2024_corrigees.xlsx
# ===================================================================

rm(list = ls(all = TRUE))

library(ggplot2)
library(dplyr)
library(readxl)
library(SPEI)
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

donnees_mensuel_zae <- donnees_raw %>%
  mutate(
    Annee = as.numeric(Annee), 
    Mois  = as.numeric(Mois),
    ZAE   = ifelse(grepl("^ZAE", ZAE), ZAE, paste("ZAE", ZAE))
  ) %>%
  filter(Annee >= 1991 & Annee <= 2024) %>%
  group_by(ZAE, Annee, Mois) %>%
  summarise(
    Pluie = mean(as.numeric(Pluie), na.rm = TRUE),
    ETP   = mean(as.numeric(ETP), na.rm = TRUE),
    .groups = 'drop'
  ) %>%
  arrange(ZAE, Annee, Mois)

liste_spei <- list()
zaes <- paste("ZAE", 1:8)

for (z in zaes) {
  df_z <- donnees_mensuel_zae %>% filter(ZAE == z)
  balance <- df_z$Pluie - df_z$ETP
  ts_balance <- ts(balance, start = c(1991, 1), frequency = 12)
  
  spei_res <- spei(ts_balance, scale = 12)
  df_z$SPEI12 <- as.numeric(spei_res$fitted)
  df_z$Date <- seq.Date(from = as.Date("1991-01-01"), to = as.Date("2024-12-01"), by = "month")
  
  liste_spei[[z]] <- df_z
}

donnees_spei_all <- bind_rows(liste_spei) %>%
  filter(!is.na(SPEI12)) %>%
  mutate(Statut = ifelse(SPEI12 >= 0, "Humide", "Sècheresse"))

creer_graph_spei <- function(data, zae_nom, letter_tag) {
  df_sub <- data %>% filter(ZAE == zae_nom)
  
  ggplot(df_sub, aes(x = Date, y = SPEI12, fill = Statut)) +
    geom_bar(stat = "identity", width = 31, color = NA) +
    geom_hline(yintercept = 0, color = "black", linewidth = 0.7) +
    geom_hline(yintercept = c(-1.5, 1.5), linetype = "dashed", color = "gray40", linewidth = 0.5) +
    scale_fill_manual(values = c("Humide" = "#0072B2", "Sècheresse" = "#D55E00")) +
    scale_x_date(date_breaks = "5 years", date_labels = "%Y", limits = c(as.Date("1991-01-01"), as.Date("2024-12-01"))) +
    scale_y_continuous(limits = c(-3, 3), breaks = seq(-3, 3, 1)) +
    labs(y = "Indice SPEI-12", x = "Années", title = zae_nom, tag = paste0("(", letter_tag, ")")) +
    publication_style_final() +
    theme(axis.text.x = element_text(size = 7.5, face = "bold", angle = 30, hjust = 1))
}

tags <- letters[1:8]
plots_spei <- lapply(1:8, function(i) creer_graph_spei(donnees_spei_all, zaes[i], tags[i]))

plan_spei_complet <- (plots_spei[[1]] + plots_spei[[2]]) / (plots_spei[[3]] + plots_spei[[4]]) / 
  (plots_spei[[5]] + plots_spei[[6]]) / (plots_spei[[7]] + plots_spei[[8]]) +
  plot_annotation(title = "Indice Standardisé de Précipitation-Évapotranspiration (SPEI-12) (1991-2024)",
                  theme = theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 13)))

ggsave("Indice_SPEI12_8ZAE_Publication.png", plot = plan_spei_complet, width = 8.5, height = 11.5, units = "in", dpi = 300)