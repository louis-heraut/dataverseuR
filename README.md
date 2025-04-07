# dataverseuR <img src="https://github.com/super-lou/dataverseuR/blob/17d88f3108a7370ab2bfe60c24e3487ab483ae9d/figures/logo_dataverseuR.png" align="right" width=160 height=160 alt=""/>

<!-- badges: start -->
[![R-CMD-check](https://github.com/super-lou/dataverseuR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/super-lou/dataverseuR/actions/workflows/R-CMD-check.yaml)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-green)](https://lifecycle.r-lib.org/articles/stages.html)
![](https://img.shields.io/github/last-commit/super-lou/dataverseuR)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md) 
<!-- badges: end -->

**dataverseuR** is a dataverse API wraper to enhance deposit procedure with only R variables declaration.


This project was carried out for National Research Institute for Agriculture, Food and the Environment (Institut National de Recherche pour l’Agriculture, l’Alimentation et l’Environnement, [INRAE](https://agriculture.gouv.fr/inrae-linstitut-national-de-recherche-pour-lagriculture-lalimentation-et-lenvironnement)).


## Installation
For latest development version
``` r
remotes::install_github("super-lou/dataverseuR")
```

## Documentation
DataverseuR as two separate sides, one for simpliying dataverse API actions with simples R functions that use `dplyr::tibble` formating and a second one for simplify metadata generation that can be complexe with json files.


### Authentification
First step is to allow the dataverse instance to authentificate you. For that the easiest way is to use a `.env` file in your working directory.

> ⚠️ Warning : NEVER GIVE YOUR CREDENTIAL (for example throught a git repository)

DataverseuR has a built in function for that step, just run 
``` R
create_dotenv()
```
and a `dist.env` file will be created in your working directory. The following step is to fill in your credential.<br>
For that, go to your dataverse instance and create a token. For example, for the demo Recherche Data Gouv instance of `BASE_URL` : [https://demo.recherche.data.gouv.fr](https://demo.recherche.data.gouv.fr) click on your account name, find the [API token tab](https://demo.recherche.data.gouv.fr/dataverseuser.xhtml?selectTab=apiTokenTab) and copy your token to the `API_TOKEN` variable in the `dist.env` file like
``` bash
# .env

API_TOKEN=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
BASE_URL=https://demo.recherche.data.gouv.fr

```
Then, rename the file `.env` and if you are in a git project, add `.env` to your `.gitignore` file.<br>

Now you should be able to use the API without issue by running this line in your working directory :
``` R
dotenv::load_dot_env()
```


### API actions
You can find the entire API documentation [here](https://guides.dataverse.org/en/latest/api/index.html). Obviously not all API actions have been convert to R function, only a small subset are in order to simplify global use of the package. If you need an other function, take to time to create it and open a pull request or create an issue.<br>

Below is a list of all the possible API actions.<br>

#### For general API actions
- `search_datasets()` to perform a search on dataverse like
``` R
# Find all the published dataset that contain the word climate in their title 
datasets = search_datasets(query="title:'climate'",
                           publication_status="RELEASED",
                           type="dataset",
                           dataverse="",
                           n_search=1000)
```
that returns
``` R
> datasets
# A tibble: 73 × 28
   name             type  url   dataset_DOI description published_at publisher
   <chr>            <chr> <chr> <chr>       <chr>       <chr>        <chr>    
 1 Plot Climate In… data… http… doi:10.154… "Climate d… 2020-11-03T… AMAP ECO…
 2 European climat… data… http… doi:10.154… "This data… 2022-09-21T… Landmark…
 3 Species plots: … data… http… doi:10.154… "The soil … 2020-11-25T… AMAP ECO…
 4 Data for “Inter… data… http… doi:10.577… "“Internat… 2022-10-26T… Experime…
 5 Tree NSC, RAP a… data… http… doi:10.154… "Data used… 2022-01-28T… AMAP     
 6 Soil and crop m… data… http… doi:10.577… "This work… 2022-07-27T… CLIMASOMA
 7 Climate effect … data… http… doi:10.577… "It holds … 2022-12-13T… URGI     
 8 Atmospheric cli… data… http… doi:10.154… "The datas… 2021-06-06T… AnaEE-Fr…
 9 Growth and annu… data… http… doi:10.154… "The prese… 2021-09-28T… Etude_Pr…
10 R script to gen… data… http… doi:10.577… "Ce dossie… 2023-02-13T… Data INR…
# ℹ 63 more rows
# ℹ 21 more variables: citationHtml <chr>, identifier_of_dataverse <chr>,
#   name_of_dataverse <chr>, citation <chr>, storageIdentifier <chr>,
#   subjects <list>, fileCount <int>, versionId <int>, versionState <chr>,
#   majorVersion <int>, minorVersion <int>, createdAt <chr>, updatedAt <chr>,
#   contacts <list>, authors <list>, keywords <list>, publications <list>,
#   producers <list>, geographicCoverage <list>, dataSources <list>, …
# ℹ Use `print(n = ...)` to see more rows
```

- `create_datasets()` to create datasets
``` R
initialise_metadata()
source(metadata_path)
res = generate_metadata()
dataset_DOI = create_datasets(dataverse="",
                              metadata_path=res$metadata_path)
```
See more information about the metadata creation in [this section](#metadata-generation).<br>
See the documentation of each function for more explaination but they are quite self explanatory.<br>

- `modify_datasets()` to modify datasets metadata
- `add_datasets_files()` to add files to datasets 
- `delete_datasets_files()` to delete files from datasets
- `delete_all_datasets_files()` to delete all files from datasets
- `publish_datasets()` to publish datasets
- `delete_datasets()` to delete datasets

#### For information about datasets
- `list_datasets_files()` to list files of datasets like
``` R
dataset_DOI = "doi:10.57745/LNBEGZ"
files = list_datasets_files(dataset_DOI)
```
that returns
``` R
> files
# A tibble: 69 × 24
   dataset_DOI        label restricted directoryLabel version datasetVersionId
   <chr>              <chr> <lgl>      <chr>            <int>            <int>
 1 doi:10.57745/LNBE… cent… FALSE      trendEX              1           276347
 2 doi:10.57745/LNBE… cent… FALSE      dataEX               1           276347
 3 doi:10.57745/LNBE… data… FALSE      NA                   1           276347
 4 doi:10.57745/LNBE… dtLF… FALSE      dataEX               1           276347
 5 doi:10.57745/LNBE… dtLF… FALSE      trendEX              1           276347
 6 doi:10.57745/LNBE… EGU2… FALSE      NA                   1           276347
 7 doi:10.57745/LNBE… endL… FALSE      dataEX               1           276347
 8 doi:10.57745/LNBE… endL… FALSE      trendEX              1           276347
 9 doi:10.57745/LNBE… ETAL… FALSE      NA                   1           276347
10 doi:10.57745/LNBE… meta… FALSE      NA                   1           276347
# ℹ 59 more rows
# ℹ 18 more variables: categories <list>, id <int>, file_DOI <chr>,
#   pidURL <chr>, filename <chr>, contentType <chr>, filesize <int>,
#   storageIdentifier <chr>, originalFileFormat <chr>,
#   originalFormatLabel <chr>, originalFileSize <int>,
#   originalFileName <chr>, UNF <chr>, rootDataFileId <int>, md5 <chr>,
#   checksum <df[,2]>, creationDate <chr>, description <chr>
# ℹ Use `print(n = ...)` to see more rows
```

- `get_datasets_metadata()` to get the metadata list of datasets<br>
Once you get the metadata as a `list` of `list`, it's kind of a difficult object to modify. To know how you can handle it using R formating variable go to the [following section](#metadata-generation) about metadata generation. 

- `download_datasets_files()` to download files of datasets
- `get_datasets_size()` to get the size of datasets
- `get_datasets_metrics()` to get the metrics about datasets

#### Others
- `convert_DOI_to_URL()` to convert a DOI to an URL


### Metadata generation
#### Metadata management
The idea of this formalism is to be able to create dataverse metadata directly inside a R code with only R variables.<br>
The metadata base file from dataverse is a json file which is represented by a complexe list nested structure in R. So, in order to simplify this, every value entry in this json file (or so every metadata in dataverse) is linked to a R variable.
``` R
# Create a metadata for the title of the futur dataset in dataverse
META$title = "Hydrologicals projections of discharge for the model {MODEL}"
```

In the above example, their is several point to understand. Every metadata variables needs to be clearly identifed as this. So :
- the name of the variable is precise and not negociable (you need to take an [example](https://github.com/super-lou/dataverseuR_toolbox) to start from it or download a metadata from dataverse with the function `get_datasets_metadata()` to find a metadata name, see [metadata importation](#metadata-importation))
- the variable needs to be stored in a variable environment clearly identify here : `META`

So this way, you can create a R file that gather all that R metadata variables like that :

``` R
META$title = "Hydrological projections of discharge for the model {MODEL}"

META$alternativeURL = "https://other-datarepository.org"

META$datasetContactName = "Dany, Doe"
META$datasetContactAffiliation = "Laboratory, Institut, Country"
META$datasetContactEmail = "dany.doe@institut.org"

META$authorName1 = "Dany, Doe"
META$authorAffiliation1 = "Laboratory, Institut, Country"
META$authorIdentifierScheme1 = "ORCID"
META$authorIdentifier1 = "xxxx-xxxx-xxxx-xxxx"

META$contributorType = "Data Curator"
META$contributorName = "Jack, "
META$contributorAffiliation = "INRAE, UR RiverLy, Villeurbanne, France"
META$contributorIdentifierScheme = "ORCID"
META$contributorIdentifier = "0009-0006-4372-0923"

META$producerName = "Producer"
META$producerURL = "https://producer.org"
META$producerLogoURL = "https://producer.org/logo.png"

META$distributorName = "Dataverse instance"
META$distributorURL = "https://dataverse.org"
META$distributorLogoURL = "https://dataverse.org/logo.png"

META$dsDescriptionValue = "description"

META$dsDescriptionLanguage = "English"
META$language = "English"
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
META$kindOfDataOther = "Hydrological projections (discharge)"
META$dataOrigin = "simulation data"

META$softwareName = "{MODEL}"
META$softwareVersion = "x"

META$publicationCitation = "futur publication"
META$publicationIDType = "doi"
META$publicationIDNumber = "doi"
META$publicationURL = "https://doi.org"

META$projectAcronym = "Project"
META$projectTitle = "Project : long title"
META$projectURL = "https://project.org"

META$timePeriodCoveredStart = "1976-01-01"
META$timePeriodCoveredEnd = "2100-12-31"

META$country = "France"

META$depositor = "DOE, DANY"
```

And this way insert a new author with 
``` R
META$authorName2 = "Michelle, Boy"
META$authorAffiliation2 = "Laboratory, An other Institut, Country"
```
(notice the numeral incrementation), or modify a metadata variable in a for loop with placeholder like `{MODEL}` with
``` R
for (model in Models) {
    META$title = gsub("[{]MODEL[}]", model, META$title)
}
```

#### Metadata generation workflow
All this R formating metadata variables needs to be action by R function.
The workflow is by consequence :
1. Initialise a metadata variable environment
```R
initialise_metadata()
```
2. Assign R metadata variables like previously seen in your current script or source an external R script 
```R
source("/path/to/metadata/Rfile.R")
```
3. Generate the json file
```R
res = generate_metadata()
```

And you will now be able to import to a dataverse instance this metadata json file with the [previously seen](#for-general-api-actions) `create_datasets()` function.


#### Metadata importation
It is possible to get metadata from an existing dataset on the dataverse with `get_datasets_metadata()`. This will import the json equivalent of the metadata. From this point, you can convert this json formating to a R file that contain all the R metadata variable formalism with the function `convert_metadata()` like 
``` R
dataset_DOI = "doi:10.57745/LNBEGZ"
metadata = get_datasets_metadata(dataset_DOI=dataset_DOI)
convert_metadata(metadata)
```
> ⚠️ Warning : Idealy this R metadata variables file should be directly reusable to create a new dataset but the numeric information for ordering duplicable metadata are not manage for now and still under developement. You can just add manualy this ordering numerical information for now.


### Workflow examples
An entire repository is dedicating to use case in [dataverseuR_toolbox](https://github.com/super-lou/dataverseuR_toolbox).<br>
If you need help to create a personal workflow and you don't find what you need in those examples, [open an issue](https://github.com/super-lou/dataverseuR_toolbox/issues).


## FAQ
*I have a question.*

-   **Solution**: Search existing issue list and if no one has a similar question create a new issue.

*I found a bug.*

-   **Good Solution**: Search existing issue list and if no one has reported it create a new issue.
-   **Better Solution**: Along with issue submission provide a minimal reproducible example of the bug.
-   **Best Solution**: Fix the issue and submit a pull request. This is the fastest way to get a bug fixed.


## Code of Conduct
Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
