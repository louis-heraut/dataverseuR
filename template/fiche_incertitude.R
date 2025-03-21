#     _        _                                            
#  __| | __ _ | |_  __ _ __ __ ___  _ _  ___ ___  _  _  _ _ 
# / _` |/ _` ||  _|/ _` |\ V // -_)| '_|(_-</ -_)| || || '_|
# \__,_|\__,_| \__|\__,_| \_/ \___||_|  /__/\___| \_,_||_|  __________
# GitHub : https://github.com/super-lou/dataverseur
#
# This file is a parameterization file used by the dataverseur R
# package to generate a metadata JSON file needed by the Dataverse API
# to create or modify a dataset.
#
# The variable declaration can be done outside of this file as long as
# it is done in the META environment.


META$file_name = "dataset_template"

META$title = "Fiches incertitudes des modèles hydrologiques de surface du projet Explore2 : XXX"

META$datasetContactName = "Évin, Guillaume"
META$datasetContactAffiliation = "INRAE, UMR IGE, Grenoble, France"
META$datasetContactEmail = "guillaume.evin@inrae.fr"


META$authorName1 = "Évin, Guillaume"
META$authorAffiliation1 = "INRAE, UMR IGE, Grenoble, France"
META$authorIdentifierScheme1 = "ORCID"
META$authorIdentifier1 = "0000-0003-3456-9441"

# META$authorName2 = "Héraut, Louis"
# META$authorAffiliation2 = "INRAE, UR RiverLy, Villeurbanne, France"
# META$authorIdentifierScheme2 = "ORCID"
# META$authorIdentifier2 = "0009-0006-4372-0923"

# META$authorName3 = "Vidal, Jean-Philippe"
# META$authorAffiliation3 = "INRAE, UR RiverLy, Villeurbanne, France"
# META$authorIdentifierScheme3 = "ORCID"
# META$authorIdentifier3 = "0000-0002-3748-6150"

# META$authorName4 = "Sauquet, Éric"
# META$authorAffiliation4 = "INRAE, UR RiverLy, Villeurbanne, France"
# META$authorIdentifierScheme4 = "ORCID"
# META$authorIdentifier4 = "0000-0001-9539-7730"


META$producerName = "Explore2"
META$producerURL = "https://professionnels.ofb.fr/fr/node/1244"
META$producerLogoURL = "https://entrepot.recherche.data.gouv.fr/logos/202158/LogoExplore2.png"

META$productionDate = "2024-06-13"

META$distributorName = "Entrepôt-Catalogue Recherche Data Gouv"
META$distributorURL = "https://entrepot.recherche.data.gouv.fr"
META$distributorLogoURL = "https://s3.fr-par.scw.cloud/rdg-portal/logos-macarons/Macarons%20Recherche%20Data%20Gouv_Entrep%C3%B4t.png"


META$dsDescriptionValue ="Ensemble de fiche descriptives des incertitudes du projet Explore2 aux points de simulation pour la région hydrologique <b>XXX</b><br>\n<hr>\n<a href=\"https://doi.org/10.57745/JUPE21\" target=\"_blank\">Accompagnement de lecture des fiches Incertitudes</a>\n<br>\nLe projet Explore2 a produit une quantité inédite de données hydrologiques. Ainsi, des ensembles de projections hydrologiques ont été élaborés sur près de 4000 points de simulation répartis en France hexagonale. Les fiches incertitudes visent à décrire les incertitudes de ces ensembles pour chacun des 3991 points de simulations hydrologiques (surface) obtenus avec la méthode de correction ADAMONT, pour trois indicateurs: QA, QJXA, et QMNA. Les valeurs numériques ne doivent pas être lues sur ces fiches, mais dans les fichiers de données brutes ou d’indicateurs pré-calculés mis à disposition, comme les fiches de synthèse, sur le portail « DRIAS les futurs de l’eau ». Ce document a pour objectif d’expliciter le contenu de ces fiches de synthèse des incertitudes.\n<hr>"
META$dsDescriptionLanguage = "French"
META$dsDescriptionDate = "2024-11-29"

META$language = "French"

META$subject = "Earth and Environmental Sciences"


META$keywordValue1 = "fiche incertitudes"

META$keywordValue2 = "synthèse graphique"

META$keywordValue3 = "incertitudes"

META$keywordValue4 = "modélisation hydrologique"
META$keywordVocabulary4 = "INRAE Thesaurus"
META$keywordVocabularyURI4 = "https://thesaurus.inrae.fr/thesaurus-inrae/fr/"
META$keywordTermURL4 = "http://opendata.inrae.fr/thesaurusINRAE/c_15613"

META$keywordValue5 = "changement climatique"
META$keywordVocabulary5 = "INRAE Thesaurus"
META$keywordVocabularyURI5 = "https://thesaurus.inrae.fr/thesaurus-inrae/fr/"
META$keywordTermURL5 = "http://opendata.inrae.fr/thesaurusINRAE/c_11564"

META$keywordValue6 = "adaptation au changement climatique"
META$keywordVocabulary6 = "INRAE Thesaurus"
META$keywordVocabularyURI6 = "https://thesaurus.inrae.fr/thesaurus-inrae/fr/"
META$keywordTermURL6 = "http://opendata.inrae.fr/thesaurusINRAE/c_1070"

META$keywordValue7 = "atténuation du changement climatique"
META$keywordVocabulary7 = "INRAE Thesaurus"
META$keywordVocabularyURI7 = "https://thesaurus.inrae.fr/thesaurus-inrae/fr/"
META$keywordTermURL7 = "http://opendata.inrae.fr/thesaurusINRAE/c_d23aa503"


META$topicClassValue1 = "Hydrologie"
META$topicClassVocab1 = "INRAE Thésaurus"
META$topicClassVocabURI1 = "http://opendata.inrae.fr/thesaurusINRAE/c_1108"

META$topicClassValue2 = "Incertitudes"

META$kindOfData = "Image"
META$kindOfDataOther = "Fiche incertitudes"

META$publicationCitation = "Accompagnement de lecture des fiches Incertitudes"
META$publicationURL = "https://doi.org/10.57745/JUPE21"
