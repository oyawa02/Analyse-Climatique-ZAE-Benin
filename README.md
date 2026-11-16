<div align="center">

#  Analyse Agroclimatique, Sécheresses et Projections CMIP6 dans les 8 ZAE du Bénin

[![R](https://img.shields.io/badge/R-4.3%2B-276DC3?style=for-the-badge&logo=r&logoColor=white)](https://www.r-project.org/)
[![CMIP6](https://img.shields.io/badge/Modèles-CMIP6_Multi--Scénarios-2E8B57?style=for-the-badge)](https://pcmdi.llnl.gov/CMIP6/)
[![Spatial](https://img.shields.io/badge/SIG-sf_%7C_ggplot2_%7C_IDW-D97706?style=for-the-badge)](#)
[![Zone d'étude](https://img.shields.io/badge/Couverture-8_ZAE_du_Bénin-0F766E?style=for-the-badge)](#)

*Caractérisation spatio-temporelle des tendances historiques (1991–2024), de la sévérité des sécheresses (SPEI-12) et des projections thermiques et pluviométriques aux horizons 2030, 2050 et 2100.*

</div>

---

## 📌 Présentation du projet

Ce dépôt rassemble l'ensemble des **scripts R**, des **données synthétiques**, de la **méthodologie statistique** et des **interprétations scientifiques** développés pour évaluer la dynamique hydroclimatique des **huit Zones Agroécologiques (ZAE) du Bénin**.

> [!NOTE]
> **Objectif scientifique :** Fournir un diagnostic agroclimatique reproductible couplant l'analyse des séries historiques observées (1991–2024) et les simulations multimodèles CMIP6 biais-corrigées afin d'éclairer les stratégies d'adaptation agricole et territoriale.

---

## 🗂️ Architecture du dépôt

```text
Analyse-Climatique-ZAE-Benin/
├── 📄 README.md                                  # Présentation générale et guide d'exécution
├── 📂 data/                                      # Jeux de données traités et statistiques
│   └── Tableau_Mann_Kendall_Sen_ZAE.csv          # Résultats des tests de tendance par ZAE
├── 📂 docs/                                      # Documentation scientifique (Word)
│   ├── Methodologie.docx                         # Protocole analytique, données et modèles
│   └── Interpretations.docx                      # Commentaires détaillés des résultats et figures
├── 📂 figures/                                   # Planches graphiques haute résolution
│   └── Indice_SPEI12_8ZAE_Publication.jpg        # Évolution du SPEI-12 (1991–2024)
└── 📂 scripts/                                   # Chaîne de traitement sous R
    ├── 01_tendances_mann_kendall_sen.R           # Tests non paramétriques (MK & pente de Sen)
    ├── 02_indices_secheresse_SPI_SPEI.R          # Calcul du bilan hydrique et SPEI-12
    ├── 03_projections_CMIP6_ZAE.R                # Extraction et analyse multi-horizons CMIP6
    └── 04_cartographie_spatialisation_ZAE.R      # Interpolation IDW et cartographie sf/ggplot2
