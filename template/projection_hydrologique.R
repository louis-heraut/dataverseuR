
META$file_name = "dataset_template"

META$title = "Projections hydrologiques Explore2 du débit pour le modèles {HM} sous {RCP}"

META$alternativeURL = "https://www.drias-climat.fr/commande"

META$datasetContactName = "Sauquet, Éric"
META$datasetContactAffiliation = "INRAE, UR RiverLy, Villeurbanne, France"
META$datasetContactEmail = "eric.sauquet@inrae.fr"

META$authorName1 = "Sauquet, Éric"
META$authorAffiliation1 = "INRAE, UR RiverLy, Villeurbanne, France"
META$authorIdentifierScheme1 = "ORCID"
META$authorIdentifier1 = "0000-0001-9539-7730"


META$contributorType = "Data Curator"
META$contributorName = "Héraut, Louis"
META$contributorAffiliation = "INRAE, UR RiverLy, Villeurbanne, France"
META$contributorIdentifierScheme = "ORCID"
META$contributorIdentifier = "0009-0006-4372-0923"


META$producerName = "Explore2"
META$producerURL = "https://professionnels.ofb.fr/fr/node/1244"
META$producerLogoURL = "https://entrepot.recherche.data.gouv.fr/logos/202158/LogoExplore2.png"

META$distributorName = "Entrepôt-Catalogue Recherche Data Gouv"
META$distributorURL = "https://entrepot.recherche.data.gouv.fr"
META$distributorLogoURL = "https://s3.fr-par.scw.cloud/rdg-portal/logos-macarons/Macarons%20Recherche%20Data%20Gouv_Entrep%C3%B4t.png"


META$dsDescriptionValue = "<b>Débit journalier</b> simulé par le modèle hydrologique <b>{HM}</b> pour l'ensemble des projections climatiques Explore2 sous <b>{RCP}</b>. Ces projections sont concaténées temporellement avec la partie historique commune à chaque RCP.<br><br>

Ce dépôt regroupe un fichier NetCDF par couple GCM/RCM et correction de biais. Retrouvez davantage d'information sur la chaîne de modélisation dans les métadonnées des fichiers NetCDF et le rapport LIEN.<br>
Plus d'information sur les modèles hydrologiques utilisés est donnée dans le rapport LIEN. Retrouvez aussi une information localisée avec les fiches de diagnostic disponibles par régions hydrologiques ici : <a href='https://doi.org/10.57745/DMFUXW' target='blank_'>https://doi.org/10.57745/DMFUXW</a>.<br><br>

<b>Métadonnées supplémentaires</b> : <ul>
<li>Détails de l'ensemble des chaînes de modélisations : <a href='' target='blank_'>à faire</a></li>
<li>Détails de l'ensemble des points de simulation : <a href='https://doi.org/10.57745/UTKWR5' target='blank_'>https://doi.org/10.57745/UTKWR5</a></li>
<li>Liste des simulations des chaînes de projections que l'on peut considéré comme aberrants / horsains par rapport à l'ensemble des chaînes de modélisation : <a href='https://doi.org/10.57745/YZNENQ' target='blank_'>https://doi.org/10.57745/YZNENQ</a></li></ul>

<b>Détail du nom des fichiers NetCDF séparé par des \"_\"</b> :<br>
{1}:  Variable : Nom de la variable (avec Adjust si les données sont corrigées)<br>
{2}:  Domain : Couverture spatiale des données<br>
{3}:  GCM-Inst-Model : Identifiant du GCM forçeur = Institut-Modèle<br>
{4}:  Experiment : Identifiant de l’expérience historique ou future via le scénario<br>
{5}:  Member : numéro du membre de l'ensemble<br>
{6}:  RCM-Inst-Model : Identifiant du RCM = Institut-Modèle<br>
{7}:  Version : Identifiant de l’expérience historique ou future via le scénario<br>
{8}:  Bc-Inst-Method-Obs-Period : Identifiant de la méthode de correction de biais statistique =
Institut-Méthode-Réanalyse-Période<br>
{9}:  HYDRO-Inst-Model : Identifiant du HYDRO = Institut-Modèle<br>
{10}: TimeFrequency : Le pas de temps du jeu de données<br>
{11}: Startyear-Endyear: Couverture temporelle des données sous forme YYYYMMDD-YYYYMMDD<br>"

META$dsDescriptionLanguage = "French"
META$language = "French"
META$subject = "Earth and Environmental Sciences"


META$keywordValue1 = "hydrology"
META$keywordTermURL1 = "http://opendata.inrae.fr/thesaurusINRAE/c_11593"
META$keywordVocabulary1 = "INRAETHES"
META$keywordVocabularyURI1 = "http://opendata.inrae.fr/thesaurusINRAE/thesaurusINRAE"

META$keywordValue2 = "hydrological model"
META$keywordTermURL2 = "http://opendata.inrae.fr/thesaurusINRAE/c_1352"
META$keywordVocabulary2 = "INRAETHES"
META$keywordVocabularyURI2 = "http://opendata.inrae.fr/thesaurusINRAE/thesaurusINRAE"

META$keywordValue3 = "hydrological projection"

META$keywordValue4 = "climate change impacts"
META$keywordTermURL4 = "http://aims.fao.org/aos/agrovoc/c_13fb5a08"
META$keywordVocabulary4 = "AGROVOC"
META$keywordVocabularyURI4 = "http://aims.fao.org/aos/agrovoc/"


META$kindOfData = "Dataset"
META$kindOfDataOther = "Projections hydrologiques (débit)"
META$dataOrigin = "simulation data"


META$publicationCitation = "futur publication"
META$publicationIDType = "doi"
META$publicationIDNumber = "doi"
META$publicationURL = "https://doi.org"


META$projectAcronym = "Explore2"
META$projectTitle = "Explore2 : Des futurs de l'eau"
META$projectURL = "https://app.inrae.fr/expertise/dossier-le-projet-explore2-des-projections-hydrologiques-pour-adapter-la-gestion-de-la-ressource-en-eau/"


META$timePeriodCoveredStart = "1976-01-01"
META$timePeriodCoveredEnd = "2100-12-31"

META$country = "France hexagonale et Corse"
META$otherGeographicCoverage = "{GEO}"

META$depositor = "HERAUT, LOUIS"
