<div align="center">

# Analyse Agroclimatique, Sécheresses et Projections CMIP6 dans les 8 ZAE du Bénin

[![R](https://img.shields.io/badge/R-4.3%2B-276DC3?style=for-the-badge&logo=r&logoColor=white)](https://www.r-project.org/)
[![CMIP6](https://img.shields.io/badge/Mod%C3%A8les-CMIP6_Multi--Sc%C3%A9narios-2E8B57?style=for-the-badge)](https://pcmdi.llnl.gov/CMIP6/)
[![SIG](https://img.shields.io/badge/SIG-sf_%7C_terra_%7C_ggplot2-D97706?style=for-the-badge)](#)
[![Zone d'étude](https://img.shields.io/badge/Couverture-8_ZAE_du_B%C3%A9nin-0F766E?style=for-the-badge)](#)

*Caractérisation spatio-temporelle des tendances historiques (1991-2024), de la dynamique des sécheresses (SPEI-12) et des projections climatiques aux horizons 2030, 2050 et 2100 dans les huit Zones Agroécologiques du Bénin.*

</div>

---

## Présentation du projet

Ce dépôt rassemble les **scripts R**, les **données synthétiques**, la **méthodologie statistique** et les **interprétations scientifiques** développés pour évaluer la dynamique hydroclimatique des **huit Zones Agroécologiques (ZAE) du Bénin**.

> **Objectif scientifique :** fournir un diagnostic agroclimatique reproductible, couplant l’analyse des séries historiques observées (1991-2024) et les simulations multimodèles CMIP6 biais-corrigées, afin d’éclairer la planification agricole et les stratégies d’adaptation territoriale.

CMIP6 est la sixième phase du *Coupled Model Intercomparison Project*, qui met à disposition des sorties de modèles climatiques pour les études de projections et d’impacts climatiques.

---

## Architecture du dépôt

```text
Analyse-Climatique-ZAE-Benin/
├── README.md                                      # Présentation, méthodologie et résultats
├── data/
│   └── Tableau_Mann_Kendall_Sen_ZAE.csv           # Résultats des tests de tendance par ZAE
├── docs/
│   ├── methodologie.md                            # Protocole analytique complet
│   └── interpretations.md                         # Interprétation des figures et résultats
├── figures/
│   └── Indice_SPEI12_8ZAE_Publication.jpg         # Évolution du SPEI-12 (1991-2024)
└── scripts/
    ├── 01_tendances_mann_kendall_sen.R            # Tests de Mann-Kendall et pente de Sen
    ├── 02_indices_secheresse_SPI_SPEI.R           # Bilan hydrique et SPEI-12
    ├── 03_projections_CMIP6_ZAE.R                 # Extraction et analyse CMIP6
    └── 04_cartographie_spatialisation_ZAE.R       # Interpolation IDW et cartographie
```

### Accès direct aux documents

- [Consulter la méthodologie détaillée](docs/methodologie.md)
- [Consulter les interprétations complètes](docs/interpretations.md)
- [Explorer la table des tendances Mann-Kendall et Sen](data/Tableau_Mann_Kendall_Sen_ZAE.csv)

---

## Méthodologie synthétique

L’approche analytique repose sur quatre étapes complémentaires.

### 1. Analyse des tendances historiques (1991-2024)

- Détection des tendances monotones significatives sur les séries annuelles et saisonnières de précipitations, température moyenne (Tmoy), température maximale (Tmax), température minimale (Tmin) et évapotranspiration potentielle (ETP), à l’aide du test non paramétrique de **Mann-Kendall**.
- Quantification de l’amplitude des variations, en taux de changement annuel ou décennal, à l’aide de l’estimateur robuste de la **pente de Sen**.

### 2. Caractérisation des sécheresses (SPEI-12)

- Calcul du bilan hydrique mensuel : `D = P - ETP`, où `P` correspond aux précipitations et `ETP` à l’évapotranspiration potentielle.
- Standardisation du bilan hydrique sur une fenêtre glissante de 12 mois afin de produire l’indice **SPEI-12**.
- Identification des périodes déficitaires (`SPEI-12 < 0`), excédentaires (`SPEI-12 > 0`) et des épisodes sévères à extrêmes lorsque l’indice franchit les seuils critiques de `+1,5` ou `-1,5`.

### 3. Projections climatiques futures (CMIP6)

- Exploitation de trois modèles de circulation générale de la phase CMIP6 : **ACCESS-CM2**, **ACCESS-ESM1-5** et **CanESM5**, corrigés des biais statistiques.
- Évaluation aux horizons **2030** (court terme), **2050** (moyen terme) et **2100** (long terme).
- Analyse selon quatre trajectoires socio-économiques partagées :
  - **SSP1-2.6** : scénario sobre en émissions
  - **SSP2-4.5** : scénario intermédiaire
  - **SSP3-7.0** : scénario à émissions élevées
  - **SSP5-8.5** : scénario pessimiste

### 4. Spatialisation et cartographie SIG

- Interpolation spatiale par **pondération inverse à la distance (IDW)** sur une grille régulière.
- Agrégation zonale selon les limites vectorielles officielles des huit ZAE du Bénin.
- Système de projection utilisé : **EPSG:32631 / WGS84**.

---

## Résultats principaux

### Dynamique des sécheresses historiques (SPEI-12, 1991-2024)

- Sur l’ensemble de la période 1991-2024, les mois en déficit hydrique (`SPEI-12 < 0`) représentent entre **50,5 %** et **53,0 %** des observations selon la ZAE.
- Entre **1992 et 1994**, une sécheresse généralisée a été particulièrement sévère dans le Sud, avec un minimum historique de **-2,72** en ZAE 7. Elle a été suivie d’une phase humide marquée en 1995-1996 au Nord, avec une valeur maximale de **+2,36** en ZAE 1.
- Entre **2000 et 2013**, un contraste régional net apparaît : les excédents sont prononcés dans le Centre et le Sud, avec **+2,70** en ZAE 5 en 1999-2000 et **+2,46** en ZAE 6 en 2011, tandis que les zones soudaniennes connaissent des déficits récurrents en 2006-2007, notamment **-2,24** en ZAE 4.
- Entre **2014 et 2022**, une recrudescence des sécheresses sévères est observée sur la quasi-totalité du pays. Elle culmine entre 2014 et 2017 au Nord et au Centre, avec **-2,42** en ZAE 5, **-2,24** en ZAE 2 et **-2,20** en ZAE 1, puis se prolonge jusqu’en 2021-2022 dans la moitié méridionale.

### Projections thermiques multi-horizons (CMIP6)

| Variable | Tendance projetée | Implications agroclimatiques |
|---|---|---|
| Température moyenne (Tmoy) | Réchauffement généralisé, plus marqué du Sud vers le Nord. En 2100, la température moyenne reste comprise entre 30,5 et 31,3 °C en ZAE 1 sous SSP1-2.6, mais atteint 33,9 à 35,3 °C en ZAE 1 et 31,3 à 33,7 °C dans le Sud (ZAE 6 à 8) sous SSP5-8.5. | Accentuation du stress thermique et de la demande évaporative. |
| Température maximale (Tmax) | Intensification critique des chaleurs diurnes dans la moitié septentrionale. Sous SSP5-8.5 à l’horizon 2100, la température maximale dépasse 40 °C en ZAE 1, avec des valeurs de 40,0 à 41,4 °C. | Risques accrus d’échaudage et de stérilité pollinique pour le maïs, le coton et le sorgho. |
| Température minimale (Tmin) | Réchauffement nocturne homogène, atténuant la fraîcheur de l’harmattan. En 2100 sous SSP5-8.5, la température minimale atteint 27,9 à 29,2 °C en ZAE 1 et 27,2 à 29,6 °C sur le littoral (ZAE 8). | Hausse de la respiration nocturne des cultures et pénalisation du remplissage des grains. |

---

## Packages R mobilisés

L’exécution complète de la chaîne de traitement nécessite **R version 4.3 ou supérieure** et les packages suivants :

| Catégorie | Packages R | Rôle dans le workflow |
|---|---|---|
| Manipulation et structuration | `tidyverse`, `dplyr`, `tidyr`, `readr`, `lubridate`, `purrr` | Nettoyage, agrégation temporelle et structuration des séries climatiques |
| Statistiques et tendances | `trend`, `Kendall`, `modifiedmk` | Tests de Mann-Kendall, versions modifiées et estimation des pentes de Sen |
| Indices agroclimatiques | `SPEI`, `Evapotranspiration` | Calcul de l’évapotranspiration potentielle et des indices SPI et SPEI-12 |
| SIG et interpolation spatiale | `sf`, `stars`, `terra`, `gstat` | Gestion des vecteurs ZAE, interpolation IDW et extraction zonale |
| Visualisation et export | `ggplot2`, `patchwork`, `scales`, `RColorBrewer`, `viridis`, `rmarkdown`, `officer` | Production de planches multi-panneaux, cartes thématiques et rapports |

### Installation rapide des dépendances

```r
install.packages(c(
  "tidyverse", "lubridate", "trend", "Kendall", "modifiedmk",
  "SPEI", "sf", "stars", "terra", "gstat",
  "ggplot2", "patchwork", "scales", "RColorBrewer", "viridis",
  "rmarkdown", "officer"
))
```

---

## Cloner et exécuter le projet

```bash
git clone [https://github.com/oyawa02/Analyse-Climatique-ZAE-Benin.git](https://github.com/oyawa02/Analyse-Climatique-ZAE-Benin.git)
cd Analyse-Climatique-ZAE-Benin
```

Ouvrez ensuite le dossier dans **RStudio** et exécutez les scripts du répertoire `scripts/` dans l’ordre numérique :

```r
source("scripts/01_tendances_mann_kendall_sen.R")
source("scripts/02_indices_secheresse_SPI_SPEI.R")
source("scripts/03_projections_CMIP6_ZAE.R")
source("scripts/04_cartographie_spatialisation_ZAE.R")
```

---

## Auteurs

- **Ozias OROU YAWA** Géographe-Écologue, Cartographe et Analyste Spatial, Université de Parakou, Bénin
- **Dr HOUDANON Roël**
- **Dr Koissi Savi Merveille**
