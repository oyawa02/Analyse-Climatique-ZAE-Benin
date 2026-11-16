\# Analyse des Tendances Historiques, Sécheresses et Projections Climatiques dans les 8 ZAE du Bénin



Ce dépôt regroupe les scripts R, la méthodologie statistique et les interprétations scientifiques relatifs à la caractérisation agroclimatique des huit Zones Agroécologiques (ZAE) du Bénin (période historique 1991–2024 et horizons futurs 2030, 2050 et 2100).



\## Structure du projet

\- `scripts/` : Codes R pour les tests de tendance (Mann-Kendall, pente de Sen), le calcul des indices SPI-12/SPEI-12, l'extraction CMIP6 et la cartographie sous `ggplot2`/`sf`.

\- `docs/methodologie.md` : Protocole analytique complet (correction de biais, modèles retenus, seuils de sécheresse).

\- `docs/interpretations\_resultats.md` : Synthèse analytique des résultats par paramètre ($T\_{moy}$, $T\_{max}$, $T\_{min}$, précipitations, SPEI-12).

\- `data/` : Tableaux synthétiques des résultats statistiques (ex. `Tableau\_Mann\_Kendall\_Sen\_ZAE.csv`).

\- `figures/` : Planches graphiques haute résolution prêtes pour publication.



\## Aperçu méthodologique

1\. \*\*Données historiques (1991–2024)\*\* : Détection des tendances monotones via le test non paramétrique de Mann-Kendall et estimation de l'amplitude par la pente de Sen.

2\. \*\*Indices de sécheresse\*\* : Calcul du SPEI-12 (Standardized Precipitation-Evapotranspiration Index à 12 mois) intégrant le bilan précipitations-évapotranspiration (ETP).

3\. \*\*Projections climatiques (CMIP6)\*\* : Évaluation multi-modèles (\*\*ACCESS-CM2\*\*, \*\*ACCESS-ESM1-5\*\*, \*\*CanESM5\*\*) sous quatre trajectoires socio-économiques partagées (\*\*SSP1-2.6\*\*, \*\*SSP2-4.5\*\*, \*\*SSP3-7.0\*\*, \*\*SSP5-8.5\*\*) aux horizons \*\*2030\*\*, \*\*2050\*\* et \*\*2100\*\*.



\## Reproduction des analyses

1\. Cloner le dépôt :

&#x20;  ```bash

&#x20;  git clone \[https://github.com/oyawa02/Analyse-Climatique-ZAE-Benin.git](https://github.com/oyawa02/Analyse-Climatique-ZAE-Benin.git)

