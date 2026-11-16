# ============================================================
# CALCUL DE L'ETP MENSUELLE PAR HARGREAVES-SAMANI (FAO-56)
# Données : 77 communes du Bénin, 1991-2024
# Sortie : nouvelle colonne ETP_Hargreaves_Corrigee (mm/mois)
# ============================================================

rm(list = ls(all= TRUE))
setwd("C:/Users/pc/Desktop/DR ROEL GIZ/Données_update/Données climatiques/Dossier_Correction_Biais/Resultats_Correction_Biais")
# 1. Charger les packages
library(dplyr)
library(lubridate)

# 2. Définir le chemin du fichier
fichier_entree <- "climat_77_communes_benin_1991_2024_LOCI_QM_corriges.csv"

# 3. Importer les données
donnees <- read.csv(
  fichier_entree,
  header = TRUE,
  sep = ",",
  dec = ".",
  stringsAsFactors = FALSE,
  fileEncoding = "UTF-8"
)

# Vérification des colonnes indispensables
colonnes_requises <- c(
  "Commune", "Annee", "Mois", "Latitude",
  "Tmin_Corrigee", "Tmax_Corrigee"
)

if (!all(colonnes_requises %in% names(donnees))) {
  stop("Certaines colonnes nécessaires sont absentes du fichier.")
}

# 4. Fonction vectorisée pour le calcul du rayonnement extraterrestre Ra
# Adaptée pour gérer l'année exacte (prise en compte des années bissextiles)
calculer_Ra_vectorise <- function(latitude, annee, mois) {
  
  # Date du milieu du mois (ex: 15 du mois)
  date_milieu <- make_date(annee, mois, 15)
  
  # Jour de l'année (1 à 365/366)
  J <- yday(date_milieu)
  
  # Nombre total de jours dans l'année
  n_jours_annee <- ifelse(leap_year(annee), 366, 365)
  
  # Latitude en radians
  phi <- latitude * pi / 180
  
  # Distance relative Terre-Soleil (dr)
  dr <- 1 + 0.033 * cos(2 * pi * J / n_jours_annee)
  
  # Déclinaison solaire (delta en radians)
  delta <- 0.409 * sin((2 * pi * J / n_jours_annee) - 1.39)
  
  # Angle horaire au coucher du soleil (omega_s)
  arg <- -tan(phi) * tan(delta)
  arg <- pmax(-1, pmin(1, arg)) # Sécurité numérique [-1, 1]
  omega_s <- acos(arg)
  
  # Constante solaire Gsc = 0.0820 MJ m-2 min-1
  Gsc <- 0.0820
  
  # Ra en MJ m-2 jour-1
  Ra_MJ <- (24 * 60 / pi) * Gsc * dr * (
    omega_s * sin(phi) * sin(delta) +
      cos(phi) * cos(delta) * sin(omega_s)
  )
  
  # Conversion de MJ m-2 jour-1 en mm/jour (1 MJ/m² = 0.408 mm d'eau)
  Ra_mm <- Ra_MJ * 0.408
  
  return(Ra_mm)
}

# 5. Calculs des métriques ETP (opérations vectorisées)
donnees_finales <- donnees %>%
  mutate(
    # Rayonnement extraterrestre (mm/jour)
    Ra_mm_jour = calculer_Ra_vectorise(Latitude, Annee, Mois),
    
    # Température moyenne (°C)
    Tmoy_Corrigee = (Tmin_Corrigee + Tmax_Corrigee) / 2,
    
    # Évapotranspiration de référence journalière (mm/jour)
    ET0_Hargreaves_mm_jour = 0.0023 * Ra_mm_jour * (Tmoy_Corrigee + 17.8) * sqrt(pmax(0, Tmax_Corrigee - Tmin_Corrigee)),
    
    # Nombre de jours dans le mois
    Nb_jours_mois = days_in_month(make_date(Annee, Mois, 1)),
    
    # ETP mensuelle cumulée (mm/mois)
    ETP_Hargreaves_Corrigee = ET0_Hargreaves_mm_jour * Nb_jours_mois
  ) %>%
  # 6. Arrondir les variables calculées
  mutate(
    Ra_mm_jour = round(Ra_mm_jour, 3),
    ET0_Hargreaves_mm_jour = round(ET0_Hargreaves_mm_jour, 3),
    ETP_Hargreaves_Corrigee = round(ETP_Hargreaves_Corrigee, 2)
  )

# 7. Résumé statistique de contrôle
print("=== RÉSUMÉ DES DONNÉES ETP CALCULÉES ===")
summary(donnees_finales$ETP_Hargreaves_Corrigee)

# 8. Exporter le résultat
fichier_sortie <- "climat_77_communes_benin_1991_2024_ETP_Hargreaves_corrigees.csv"

write.csv(
  donnees_finales,
  fichier_sortie,
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

cat("\nLe fichier a été créé avec succès :", fichier_sortie, "\n")