**Cadre spatial et structuration de l'échantillonnage**

L'analyse couvre l'intégralité du territoire de la République du Bénin à
une résolution administrative correspondant aux 77 communes du pays.
Afin de rendre compte du gradient climatique latitudinal (du régime
subéquatorial bimodal au Sud au régime soudano-sahélien unimodal à
l'Extrême-Nord) et des spécificités pédoclimatiques nationales (Emmanuel
et al., 2019; MAEP, 2017), les 77 communes ont été géolocalisées par
leurs centroïdes géographiques (système de référence géodésique WGS 84,
EPSG :4326) et regroupées selon le découpage officiel des huit (08)
Zones Agro-Écologiques (ZAE) du Bénin (Tableau 1).

| **ZAE** | **Désignation** | **Communes** | **N** |
|:--:|----|----|:--:|
| ZAE 1 | Zone extrême Nord-Bénin | Karimama, Malanville | 2 |
| ZAE 2 | Zone cotonnière du Nord-Bénin | Banikoara, Bembèrèkè, Gogounou, Kandi, Kalalé, Kérou, Pèrèrè, Ségbana | 8 |
| ZAE 3 | Zone vivrière du Sud-Borgou | Kouandé, N'Dali, Nikki, Péhunco, Parakou, Sinendé | 6 |
| ZAE 4 | Zone Ouest-Atacora | Boukombé, Cobly, Copargo, Djougou, Matéri, Natitingou, Ouaké, Tanguiéta, Toucountouna | 9 |
| ZAE 5 | Zone cotonnière du Centre-Bénin | Bantè, Bassila, Dassa-Zoumè, Ouèssè, Savalou, Tchaourou | 6 |
| ZAE 6 | Zone des terres de barre | Abomey-Calavi, Allada, Aplahoué, Bopa, Comè, Djakotomey, Dogbo-Tota, Houéyogbé, Klouékanmè, Kpomassè, Lalo, Lokossa, Toffo, Tori-Bossito, Toviklin, Zè | 16 |
| ZAE 7 | Zone de la dépression | Abomey, Agbangnizoun, Bohicon, Bonou, Covè, Djidja, Glazoué, Kétou, Ouinhi, Savè, Za-Kpota, Zangnanado, Zogbodomey | 13 |
| ZAE 8 | Zone des pêcheries | Adjarra, Adja-Ouèrè, Adjohoun, Aguégués, Akpro-Missérété, Athiémé, Avrankou, Cotonou, Dangbo, Grand-Popo, Ifangni, Ouidah, Pobè, Porto-Novo, Sakété, Sèmè-Kpodji, Sô-Ava | 17 |

**Tableau 1:** Répartition des 77 communes par Zone Agro-Écologique
(ZAE)

**Collecte et sources des données climatiques**

L'étude repose sur une approche hybride combinant des observations
météorologiques de surface, des produits satellitaires et de réanalyse à
haute résolution spatiale sur la période de référence récente 1991-2024
(34 ans, couvrant la normale climatique standard 1991-2020 de
l'Organisation Météorologique Mondiale (OMM, 2017) ainsi que les années
récentes), et des simulations climatiques globales issues du projet
CMIP6 (Coupled Model Intercomparison Project Phase 6 ; (Eyring et al.,
2016)) pour les horizons futurs (2030, 2050 et 2100). Les sources
mobilisées sont récapitulées dans le Tableau 2.

<table style="width:100%;">
<caption><p><strong>Tableau 2 :</strong> Sources de données, variables
et résolutions</p></caption>
<colgroup>
<col style="width: 14%" />
<col style="width: 11%" />
<col style="width: 12%" />
<col style="width: 14%" />
<col style="width: 46%" />
</colgroup>
<thead>
<tr>
<th style="text-align: center;"><strong>Type de données</strong></th>
<th style="text-align: center;"><strong>Source / produit
(référence)</strong></th>
<th style="text-align: center;"><strong>Variables
extraites</strong></th>
<th style="text-align: center;"><strong>Résolution spatiale et
temporelle ; période</strong></th>
<th style="text-align: center;"><strong>Accès</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>Observations nationales</strong></td>
<td><strong>Météo-Bénin</strong> (6 stations synoptiques : Cotonou,
Bohicon, Savè, Parakou, Natitingou, Kandi)</td>
<td>Précipitations, T<sub>moy</sub>, T<sub>min</sub>, T<sub>max</sub>,
humidité relative, vent</td>
<td><p>Ponctuelle (stations) / mensuelle</p>
<p>1991–2024</p></td>
<td>Données institutionnelles (Agence Nationale de la Météorologie du
Bénin)</td>
</tr>
<tr>
<td><strong>Précipitations satellitaires</strong></td>
<td><strong>CHIRPS v2.0</strong></td>
<td>Précipitations (P)</td>
<td><p>0,05° (~5 km) / journalière agrégée au mois</p>
<p>1991–2024</p></td>
<td><p><a
href="https://www.chc.ucsb.edu/data/chirps">https://www.chc.ucsb.edu/data/chirps</a></p>
<p>GEE: UCSB-CHG/CHIRPS/DAILY</p></td>
</tr>
<tr>
<td><strong>Réanalyse climatique</strong></td>
<td><strong>ERA5-Land</strong></td>
<td>Température à 2 m (T<sub>moy</sub>, T<sub>min</sub>,
T<sub>max</sub>), point de rosée (T<sub>d</sub>), composantes du vent
(u<sub>10</sub>, v<sub>10</sub>)</td>
<td><p>0,1° (~9 km, rééchantillonnée à 5 km) / journalière agrégée au
mois</p>
<p>1991–2024</p></td>
<td><p><a
href="https://cds.climate.copernicus.eu">https://cds.climate.copernicus.eu</a></p>
<p>GEE: ECMWF/ERA5_LAND/DAILY_AGGR</p></td>
</tr>
<tr>
<td><strong>Baseline et projections futures</strong></td>
<td><p><strong>WorldClim v2.1 / CMIP6</strong></p>
<p>GCM: <em>ACCESS-CM2</em>, <em>ACCESS-ESM1-5</em>,
<em>CanESM5</em></p></td>
<td>P, T<sub>min</sub>, T<sub>max</sub> sous 4 scénarios (SSP1-2.6,
SSP2-4.5, SSP3-7.0, SSP5-8.5)</td>
<td><p>2,5′ d'arc (4,5–5 km) / climatologies mensuelles</p>
<p>1970–2000 et 2021–2100</p></td>
<td><p><a
href="https://www.worldclim.org/data/cmip6/cmip6climate.html">https://www.worldclim.org/data/cmip6/cmip6climate.html</a></p>
<p>via le package R geodata</p></td>
</tr>
<tr>
<td><strong>Limites administratives</strong></td>
<td><strong>GADM v4.1</strong> et découpage national des ZAE</td>
<td>Contours nationaux et limites des Zones Agro-Écologiques</td>
<td>Vecteur (EPSG:4326)</td>
<td><a href="https://gadm.org">https://gadm.org</a></td>
</tr>
</tbody>
</table>

**Extraction automatisée sous Google Earth Engine (GEE)**

Pour la période historique 1991-2024, l'extraction des séries maillées a
été automatisée sur la plateforme de traitement géospatial Google Earth
Engine <https://earthengine.google.com> (Gorelick et al., 2017).

Nous avons les données suivantes :

- **Précipitations mensuelles (P) :** cumul mensuel des précipitations
  journalières issues du produit CHIRPS v2.0 (UCSB-CHG/CHIRPS/DAILY
  (Funk et al., 2015), qui fusionne l'imagerie infrarouge thermique
  satellitaire et les stations pluviométriques *in situ*.

- **Températures (T<sub>moy</sub>, T<sub>min</sub>, T<sub>max</sub>) :**
  extraction à partir de la réanalyse terrestre ERA5-Land
  (ECMWF/ERA5_LAND/DAILY_AGGR (Muñoz-Sabater et al., 2021) avec
  conversion des kelvins en degrés Celsius.

- **Humidité relative (HR) :** calculée au pas de temps journalier selon
  la formulation psychrométrique de Magnus-Tetens (Alduchov & Eskridge,
  1996 ; Allen *et al.*, 1998) à partir de la température de l'air (T)
  et de la température du point de rosée (T<sub>d</sub>), avant
  agrégation mensuelle (Équation 1).

***HR =** 100 × exp\[17,27·T<sub>d</sub> / (T<sub>d</sub> + 237,7)\] /
exp\[17,27·T / (T + 237,7)\]* **(1)**

- **Vitesse du vent à 10 m (V<sub>10</sub>) :** calculée quotidiennement
  par la norme euclidienne des composantes zonale (u<sub>10</sub>) et
  méridienne (v<sub>10</sub>) (Équation 2).

***V<sub>10</sub>** = √ (u<sub>10</sub><sup>2</sup> +
v<sub>10</sub><sup>2</sup>)* **(2)**

- **Échantillonnage spatial :** les bandes mensuelles ont été extraites
  aux centroïdes des 77 communes via la fonction reduceRegions() à une
  échelle spatiale de 5 000 m (scale: 5000), calée sur la résolution
  native de CHIRPS.

**Acquisition des projections climatiques futures (CMIP6)**

Les données prospectives ont été acquises sous R via la fonction
cmip6_world () du package geodata (Hijmans, 2021) à une résolution
spatiale de 2,5 minutes d'arc qui correspond à 5 km, issues de la
désagrégation spatiale (*downscaling* par méthode *Delta Change* sur la
référence WorldClim v2.1 (Fick & Hijmans, 2017).

Trois Modèles de Circulation Générale (GCM) du cadre CMIP6 (Eyring et
al., 2016), reconnus pour leur représentativité en Afrique de l'Ouest,
ont été sélectionnés : ACCESS-CM2 (Bi et al., 2020), ACCESS-ESM1-5
(Ziehn et al., 2020) et CanESM5 (Swart et al., 2019).

Quatre trajectoires socio-économiques partagées (scénarios ) (SSP1-2.6,
SSP2-4.5, SSP3-7.0 et SSP5-8.5 (O’Neill et al., 2016) ont été retenues
sur trois fenêtres temporelles de 20 ans :

- **Horizon proche (2030) :** moyenne 2021–2040 ;

- **Horizon moyen (2050) :** moyenne 2041–2060 ;

- **Horizon lointain (2100) :** moyenne 2081–2100.

Les rasters mondiaux ont été découpés et masqués selon les frontières
administratives du Bénin (gadm), exportés au format GeoTIFF, puis
échantillonnés aux centroïdes des 77 communes via la fonction
terra::extract() (Hijmans et al., 2020).

**Prétraitement, calibration et calcul des indices climatiques**

L'ensemble des traitements statistiques, des calibrations et des
modélisations a été programmé sous l'environnement **R** (R Core Team,
2025) à l'aide des packages dplyr, tidyr, readxl, writexl, terra, sf,
gstat, geodata, trend et SPEI.

**Correction de biais par la méthode des quantiles (Quantile Mapping)**

Afin d'éliminer les biais systématiques inhérents aux produits
satellitaires et de réanalyse (notamment la sous-estimation des fortes
pluies ou les écarts thermiques locaux), les séries brutes issues de
CHIRPS et ERA5-Land ont été calibrées par rapport aux observations des
06 stations synoptiques de Météo-Bénin (Cotonou, Bohicon, Savè, Parakou,
Natitingou et Kandi).

La méthode non paramétrique du Quantile Mapping (QM) (Gudmundsson et
al., 2012; Maraun, 2016) a été appliquée en rattachant chaque commune à
sa station synoptique de référence selon son appartenance
agro-climatique. Cette technique ajuste la fonction de répartition
cumulative (CDF) des données modélisées (F<sub>m</sub>) sur celle des
observations de terrain (F<sub>o</sub>) selon la transformation
(Équation 3) :

*X<sub>corrigé</sub> = F<sub>o</sub><sup>−1</sup>( F<sub>m</sub>(
X<sub>brut</sub> ) )* (3)

Ce procédé permet de corriger simultanément la moyenne, la variance et
les quantiles extrêmes des variables climatiques primaires (P,
T<sub>moy</sub>, T<sub>min</sub>, T<sub>max</sub>, HR, V<sub>10</sub>).

**Calcul de l'évapotranspiration potentielle (ETP) selon
Hargreaves-Samani**

Afin de préserver la cohérence physique du bilan hydrique et d'éviter
les distorsions statistiques liées aux méthodes multivariées par copules
sur des variables déjà calibrées, l'évapotranspiration potentielle
mensuelle (ETP, en mm/mois) a été recalculée directement pour chacune
des 77 communes sur la période 1991–2024 à partir des températures
primaires corrigées (T<sub>moy</sub>, T<sub>min</sub>, T<sub>max</sub>),
selon la formulation empirique de Hargreaves et Samani (1985),
recommandée par la FAO dans le Bulletin d'irrigation et de drainage n°
56 (Allan et al., 1998) (Équation 4) :

*ETP = 0,0023 × R<sub>a</sub> × (T<sub>moy</sub> + 17,8) ×
√(T<sub>max</sub> − T<sub>min</sub>) × N* (4)

où R<sub>a</sub> représente le rayonnement extraterrestre (exprimé en
équivalent d'évaporation, en mm·j<sup>−1</sup>), calculé en fonction de
la latitude exacte de chaque commune et du mois de l'année (Allan et
al., 1998), et N le nombre de jours du mois considéré.

**Bilan climatique mensuel (BC) et indice de sécheresse (SPEI-12)**

Le Bilan climatique (BC) est évalué au pas de temps mensuel pour chaque
commune et agrégé par ZAE, il correspond à la différence entre les
apports pluviométriques et la demande évaporative (Allan et al., 1998;
Thornthwaite, 1948) (Équation 5) :

*BC = P − ETP (en mm)* (5)

Cette métrique permet d'identifier les mois hydrologiquement
excédentaires (BC \> 0) et déficitaires (BC \< 0), ainsi que la durée
utile de la saison végétative.

**Indice Standardisé de Précipitation-Évapotranspiration (SPEI-12)** est
indice développé par

(Vicente-Serrano et al., 2010), cet indice multiscalaire a été calculé à
l'échelle de 12 mois à l'aide du package R SPEI et la fonction spei(...,
scale = 12) (Beguería & Vicente-Serrano, 2011; Vicente-Serrano et al.,
2010) à partir de la série mensuelle du bilan hydrique (D<sub>i</sub> =
P<sub>i</sub> − ETP<sub>i</sub>) ajustée à une loi log-logistique à
trois paramètres. L'échelle de 12 mois permet de caractériser les
sécheresses hydrologiques et agricoles pluriannuelles, en distinguant
les épisodes modérés, sévères et extrêmes selon les seuils du Tableau 3
(Vicente-Serrano et al., 2010).

| **Classe de sécheresse** | **Intervalle du SPEI-12** |
|--------------------------|:-------------------------:|
| Sécheresse modérée       |    −1,5 \< SPEI ≤ −1,0    |
| Sécheresse sévère        |    −2,0 \< SPEI ≤ −1,5    |
| Sécheresse extrême       |        SPEI ≤ −2,0        |

**Tableau 3 :** Classes de sécheresse selon le SPEI-12

**Analyse statistique des régimes, tendances et visualisation**

**Détection des tendances et significativité statistique**

Pour quantifier l'évolution interannuelle des sept paramètres
climatiques sur la période 1991–2024 au sein de chaque ZAE, deux
approches complémentaires ont été combinées :

- **Régression linéaire ordinaire (MCO) :** estimation de la droite de
  tendance linéaire et du coefficient de détermination (R<sup>2</sup>)
  sur les cumuls annuels (pluie, ETP) et les moyennes annuelles
  (T<sub>moy</sub>, T<sub>min</sub>, T<sub>max</sub>, HR,
  V<sub>10</sub>).

- **Test non paramétrique de Mann-Kendall et estimateur de pente de Sen
  :** réalisés sous R via le package trend (Pohlert, 2015) ; à travers
  les fonctions mk.test() et sens.slope()). Insensible aux valeurs
  aberrantes et ne nécessitant pas d'hypothèse de normalité, le test de
  Mann-Kendall (Kendall, 1948; Mann, 1945) fournit le coefficient de
  corrélation de rang τ, la statistique normalisée Z et la probabilité
  critique (*p*-value aux seuils α = 0,05, 0,01 et 0,001), tandis que
  l'estimateur non paramétrique de (Sen, 1968) quantifie le taux de
  variation médian annuel et décennal (en unité/an et unité/décennie).

**Conception graphique et cartographique sous R**

Toutes les représentations graphiques ont été générées sous R afin de
garantir une homogénéité visuelle. D'une part, les planches analytiques
multi-panneaux ont été conçues à l'aide des packages ggplot2 (Wickham,
2016), ggpubr (Kassambara, 2016) ; permettant l'insertion automatique
des équations de régression linéaire et des coefficients de
détermination $`R^{2}`$ via stat_regline_equation()) et patchwork
(Pedersen, 2019) ; pour l'assemblage en grilles harmonisées 4 x 2
comparant simultanément les 8 ZAE).

**Bibliographie**

Allan, R., Pereira, L., & Smith, M. (1998). *Crop
evapotranspiration-Guidelines for computing crop water requirements-FAO
Irrigation and drainage paper 56* (Vol. 56).

Beguería, S., & Vicente-Serrano, S. M. (2011). *SPEI: Calculation of the
Standardized Precipitation-Evapotranspiration Index* (p. 1.8.1)
\[Dataset\]. https://doi.org/10.32614/CRAN.package.SPEI

Bi, D., Dix, M., Marsland, S., O’Farrell, S., Sullivan, A., Bodman, R.,
Law, R., Harman, I., Srbinovsky, J., Rashid, H. A., Dobrohotoff, P.,
Mackallah, C., Yan, H., Hirst, A., Savita, A., Dias, F. B., Woodhouse,
M., Fiedler, R., & Heerdegen, A. (2020). Configuration and spin-up of
ACCESS-CM2, the new generation Australian Community Climate and Earth
System Simulator Coupled Model. *Journal of Southern Hemisphere Earth
Systems Science*, *70*(1), 225–251. https://doi.org/10.1071/ES19040

Emmanuel, L., Hounguè, N., Biaou, C., & Badou, D. (2019). Statistical
Analysis of Recent and Future Rainfall and Temperature Variability in
the Mono River Watershed (Benin, Togo). *Climate*, *7*(1), 8.
https://doi.org/10.3390/cli7010008

Eyring, V., Bony, S., Meehl, G. A., Senior, C. A., Stevens, B.,
Stouffer, R. J., & Taylor, K. E. (2016). Overview of the Coupled Model
Intercomparison Project Phase 6 (CMIP6) experimental design and
organization. *Geoscientific Model Development*, *9*(5), 1937–1958.
https://doi.org/10.5194/gmd-9-1937-2016

Fick, S. E., & Hijmans, R. J. (2017). WorldClim 2: new 1‐km spatial
resolution climate surfaces for global land areas. *International
Journal of Climatology*, *37*(12), 4302–4315.
https://doi.org/10.1002/joc.5086

Funk, C., Peterson, P., Landsfeld, M., Pedreros, D., Verdin, J., Shukla,
S., Husak, G., Rowland, J., Harrison, L., Hoell, A., & Michaelsen, J.
(2015). The climate hazards infrared precipitation with stations—a new
environmental record for monitoring extremes. *Scientific Data*, *2*(1),
150066. https://doi.org/10.1038/sdata.2015.66

Gorelick, N., Hancher, M., Dixon, M., Ilyushchenko, S., Thau, D., &
Moore, R. (2017). Google Earth Engine: Planetary-scale geospatial
analysis for everyone. *Remote Sensing of Environment*, *202*, 18–27.
https://doi.org/10.1016/j.rse.2017.06.031

Gudmundsson, L., Bremnes, J. B., Haugen, J. E., & Engen-Skaugen, T.
(2012). Technical Note: Downscaling RCM precipitation to the station
scale using statistical transformations – a comparison of methods.
*Hydrology and Earth System Sciences*, *16*(9), 3383–3390.
https://doi.org/10.5194/hess-16-3383-2012

Hijmans, R. J. (2021). *geodata: Access Geographic Data* (p. 0.6-9)
\[Dataset\]. https://doi.org/10.32614/CRAN.package.geodata

Hijmans, R. J., Brown, A., Barbosa, A. M., Cordano, E., & Dyba, K.
(2020). *terra: Spatial Data Analysis* (p. 1.9-50) \[Dataset\].
https://doi.org/10.32614/CRAN.package.terra

Kassambara, A. (2016). *ggpubr: “ggplot2” Based Publication Ready Plots*
(p. 1.0.0) \[Dataset\]. https://doi.org/10.32614/CRAN.package.ggpubr

Kendall, M. G. (1948). *Rank Correlation Methods*. C. Griffin.
https://books.google.bj/books?id=hiBMAAAAMAAJ

MAEP. (2017). *Plan Stratégique de Développement du Secteur Agricole
(PSDSA) 2025 et Plan National d’Investissements Agricoles et de Sécurité
Alimentaire et Nutritionnelle (PNIASAN) 2017–2021* \[Plan stratégique de
développement du secteur agricole et plan national d’investissements
agricoles\]. République du Bénin, Ministère de l’Agriculture, de
l’Élevage et de la Pêche.

Mann, H. B. (1945). Nonparametric Tests Against Trend. *Econometrica*,
*13*(3), 245. https://doi.org/10.2307/1907187

Maraun, D. (2016). Bias Correcting Climate Change Simulations - a
Critical Review. *Current Climate Change Reports*, *2*(4), 211–220.
https://doi.org/10.1007/s40641-016-0050-x

Muñoz-Sabater, J., Dutra, E., Agustí-Panareda, A., Albergel, C.,
Arduini, G., Balsamo, G., Boussetta, S., Choulga, M., Harrigan, S.,
Hersbach, H., Martens, B., Miralles, D. G., Piles, M.,
Rodríguez-Fernández, N. J., Zsoter, E., Buontempo, C., & Thépaut, J.-N.
(2021). ERA5-Land: a state-of-the-art global reanalysis dataset for land
applications. *Earth System Science Data*, *13*(9), 4349–4383.
https://doi.org/10.5194/essd-13-4349-2021

OMM. (2017). *Directives de l’OMM pour le calcul des normales
climatiques*. Organisation Météorologique Mondiale.

O’Neill, B. C., Tebaldi, C., Van Vuuren, D. P., Eyring, V.,
Friedlingstein, P., Hurtt, G., Knutti, R., Kriegler, E., Lamarque,
J.-F., Lowe, J., Meehl, G. A., Moss, R., Riahi, K., & Sanderson, B. M.
(2016). The Scenario Model Intercomparison Project (ScenarioMIP) for
CMIP6. *Geoscientific Model Development*, *9*(9), 3461–3482.
https://doi.org/10.5194/gmd-9-3461-2016

Pedersen, T. L. (2019). *patchwork: The Composer of Plots* (p. 1.3.2)
\[Dataset\]. https://doi.org/10.32614/CRAN.package.patchwork

Pohlert, T. (2015). *trend: Non-Parametric Trend Tests and Change-Point
Detection* (p. 1.1.10) \[Dataset\].
https://doi.org/10.32614/CRAN.package.trend

R Core Team. (2025). *R: A Language and Environment for Statistical
Computing*. R Foundation for Statistical Computing.
https://www.R-project.org/

Sen, P. K. (1968). Estimates of the Regression Coefficient Based on
Kendall’s Tau. *Journal of the American Statistical Association*,
*63*(324), 1379–1389. https://doi.org/10.1080/01621459.1968.10480934

Swart, N. C., Cole, J. N. S., Kharin, V. V., Lazare, M., Scinocca, J.
F., Gillett, N. P., Anstey, J., Arora, V., Christian, J. R., Hanna, S.,
Jiao, Y., Lee, W. G., Majaess, F., Saenko, O. A., Seiler, C., Seinen,
C., Shao, A., Sigmond, M., Solheim, L., … Winter, B. (2019). The
Canadian Earth System Model version 5 (CanESM5.0.3). *Geoscientific
Model Development*, *12*(11), 4823–4873.
https://doi.org/10.5194/gmd-12-4823-2019

Thornthwaite, C. W. (1948). An Approach toward a Rational Classification
of Climate. *Geographical Review*, *38*(1), 55.
https://doi.org/10.2307/210739

Vicente-Serrano, S. M., Beguería, S., & López-Moreno, J. I. (2010). A
Multiscalar Drought Index Sensitive to Global Warming: The Standardized
Precipitation Evapotranspiration Index. *Journal of Climate*, *23*(7),
1696–1718. https://doi.org/10.1175/2009JCLI2909.1

Wickham, H. (2016). *ggplot2: Elegant Graphics for Data Analysis* (2nd
ed. 2016). Springer International Publishing : Imprint: Springer.
https://doi.org/10.1007/978-3-319-24277-4

Ziehn, T., Chamberlain, M. A., Law, R. M., Lenton, A., Bodman, R. W.,
Dix, M., Stevens, L., Wang, Y.-P., & Srbinovsky, J. (2020). The
Australian Earth System Model: ACCESS-ESM1.5. *Journal of Southern
Hemisphere Earth Systems Science*, *70*(1), 193–214.
https://doi.org/10.1071/ES19035
