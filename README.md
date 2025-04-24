# dataverseuR <img src="https://github.com/super-lou/dataverseuR/blob/e50a7ce8e819978059d891105334d19b61d813d4/man/figures/logo_dataverseuR_small.png" align="right" width=160 height=160 alt=""/>

<!-- badges: start -->
[![R-CMD-check](https://github.com/super-lou/dataverseuR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/super-lou/dataverseuR/actions/workflows/R-CMD-check.yaml)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-green)](https://lifecycle.r-lib.org/articles/stages.html)
![](https://img.shields.io/github/last-commit/super-lou/dataverseuR)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md) 
<!-- badges: end -->

**dataverseuR** is a dataverse API R wrapper to enhance the deposit procedure using only R variable declarations.

This project was carried out for the National Research Institute for Agriculture, Food and the Environment (Institut National de Recherche pour l’Agriculture, l’Alimentation et l’Environnement, [INRAE](https://agriculture.gouv.fr/inrae-linstitut-national-de-recherche-pour-lagriculture-lalimentation-et-lenvironnement)).


## Installation
For the latest development version:
``` r
remotes::install_github("super-lou/dataverseuR")
```


## Documentation
dataverseuR has two separate components: one simplifies dataverse API actions using simple R functions with `dplyr::tibble` formatting, and the other simplifies metadata generation, which can be complex with JSON files.


### Authentication
The first step is to authenticate with the dataverse instance. The easiest way is to use a `.env` file in your working directory.

> ⚠️ Warning: NEVER SHARE YOUR CREDENTIALS (for example, through a Git repository).

dataverseuR has a built-in function for this step. Simply run:
``` R
create_dotenv()
```
A `dist.env` file will be created in your working directory. The next step is to fill in your credentials.  
To do this, go to your dataverse instance and create a token. For example, for the demo Recherche Data Gouv instance with `BASE_URL`: [https://demo.recherche.data.gouv.fr](https://demo.recherche.data.gouv.fr), click on your account name, find the [API token tab](https://demo.recherche.data.gouv.fr/dataverseuser.xhtml?selectTab=apiTokenTab), and copy your token to the `API_TOKEN` variable in the `dist.env` file, like this:
``` bash
# .env

API_TOKEN=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
BASE_URL=https://demo.recherche.data.gouv.fr

```
Then, rename the file to `.env`, and if you are in a Git project, add `.env` to your `.gitignore` file.  

Now you should be able to use the API without issues by running this line in your working directory:
``` R
dotenv::load_dot_env()
```


### API Actions
You can find the full API documentation [here](https://guides.dataverse.org/en/latest/api/index.html). Not all API actions have been converted to R functions; only a subset has been included to simplify general use of the package. If you need another function, feel free to create it and open a pull request or create an issue.  

Below is a list of all available API actions.  

#### General API Actions
- `search_datasets()`: Performs a search on dataverse, like:
``` R
# Find all published datasets that contain the word "climate" in their title 
datasets = search_datasets(query='title:"climate"',
                           publication_status="RELEASED",
                           type="dataset",
                           dataverse="",
                           n_search=1000)
```
This returns:
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

- `create_datasets()`: Creates datasets.
``` R
initialise_metadata()
source(metadata_path)
res = generate_metadata()
dataset_DOI = create_datasets(dataverse="",
                              metadata_path=res$metadata_path)
```
For more information about metadata creation, see the [Metadata Generation](#metadata-generation) section.  
The documentation for each function is self-explanatory.  

- `modify_datasets()`: Modifies dataset metadata.
- `add_datasets_files()`: Adds files to datasets.
- `delete_datasets_files()`: Deletes files from datasets.
- `delete_all_datasets_files()`: Deletes all files from datasets.
- `publish_datasets()`: Publishes datasets.
- `delete_datasets()`: Deletes datasets.

#### Dataset Information
- `list_datasets_files()`: Lists files in datasets, like:
``` R
dataset_DOI = "doi:10.57745/LNBEGZ"
files = list_datasets_files(dataset_DOI)
```
This returns:
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

- `get_datasets_metadata()`: Retrieves the metadata list of datasets.  
Once you have the metadata as a `list` of `list`, it can be challenging to modify. To learn how to handle it using R variable formatting, refer to the [following section](#metadata-generation) about metadata generation. 

- `download_datasets_files()`: Downloads files from datasets.
- `get_datasets_size()`: Retrieves the size of datasets.
- `get_datasets_metrics()`: Retrieves metrics about datasets.

#### Others
- `convert_DOI_to_URL()`: Converts a DOI to a URL.


### Metadata Generation
#### Metadata Management
The idea behind this formalism is to create dataverse metadata directly in R code using only R variables.  
The metadata base file from dataverse is a JSON file, which is represented by a complex nested list structure in R. To simplify this, every value entry in this JSON file (i.e., every metadata field in dataverse) is linked to an R variable.
``` R
# Create metadata for the title of the future dataset in dataverse
META$title = "Hydrological projections of discharge for the model {MODEL}"
```

In the example above, there are several key points to understand. Every metadata variable must be clearly identified as such. Therefore:
- The variable name is precise and non-negotiable (you need to start from an [example](https://github.com/super-lou/dataverseuR_toolbox) or download metadata from dataverse using the function `get_datasets_metadata()` to find a metadata name; see [Metadata Importation](#metadata-importation)).
- The variable must be stored in an environment variable clearly identified here as `META`.

This way, you can create an R file that gathers all these R metadata variables, like this:

``` R
META$title = "Plane simulation trajectory for the model {MODEL}"

META$alternativeURL = "https://other-datarepository.org"

META$datasetContactName = "John, Locke"
META$datasetContactAffiliation = "Laboratory, Institut, Island"
META$datasetContactEmail = "dany.doe@institut.org"

META$authorName1 = "John, Locke"
META$authorAffiliation1 = "Laboratory, Institut, Island"
META$authorIdentifierScheme1 = "ORCID"
META$authorIdentifier1 = "xxxx-xxxx-xxxx-xxxx"

META$contributorType = "Data Curator"
META$contributorName = "Hugo, Reyes"
META$contributorAffiliation = "Laboratory, Same Institut, Island"
META$contributorIdentifierScheme = "ORCID"
META$contributorIdentifier = "4815-1623-4248-1516"

META$producerName = "Producer"
META$producerURL = "https://producer.org"
META$producerLogoURL = "https://producer.org/logo.png"

META$distributorName = "dataverse instance"
META$distributorURL = "https://dataverse.org"
META$distributorLogoURL = "https://dataverse.org/logo.png"

META$dsDescriptionValue = "A collection of 815 simulated plane trajectories designed for testing flight behavior under unusual navigational conditions. Includes data on course deviations, atmospheric anomalies, and long-range displacement events."

META$dsDescriptionLanguage = "English"
META$language = "English"
META$subject = "Earth and Environmental Sciences"

META$keywordValue1 = "atmospheric boundary layer"
META$keywordTermURL1 = "http://opendata.inrae.fr/thesaurusINRAE/c_823"
META$keywordVocabulary1 = "INRAETHES"
META$keywordVocabularyURI1 = "http://opendata.inrae.fr/thesaurusINRAE/thesaurusINRAE"

META$keywordValue2 = "magnetic characteristic"
META$keywordTermURL2 = "http://opendata.inrae.fr/thesaurusINRAE/c_13144"
META$keywordVocabulary2 = "INRAETHES"
META$keywordVocabularyURI2 = "http://opendata.inrae.fr/thesaurusINRAE/thesaurusINRAE"

META$keywordValue3 = "plane"

META$kindOfData = "Dataset"
META$kindOfDataOther = "Flying simulation"
META$dataOrigin = "simulation data"

META$softwareName = "{MODEL}"
META$softwareVersion = "x"

META$publicationCitation = "futur publication"
META$publicationIDType = "doi"
META$publicationIDNumber = "doi"
META$publicationURL = "https://doi.org"

META$projectAcronym = "Others Project"
META$projectTitle = "Others Project : long title"
META$projectURL = "https://project.org"

META$timePeriodCoveredStart = "2004-09-22"
META$timePeriodCoveredEnd = "2010-05-23"

META$country = "Hawaii"

META$depositor = "Kate, Austen"
```

This allows you to add a new author with:
``` R
META$authorName2 = "Jack, Shephard"
META$authorAffiliation2 = "Laboratory, An other Institut, Island"
```
(Note the numerical incrementation.)<br>
You can also modify a metadata variable in a for loop with placeholders like `{MODEL}`:
``` R
for (model in Models) {
    META$title = gsub("[{]MODEL[}]", model, META$title)
}
```

#### Metadata Generation Workflow
All these R-formatted metadata variables need to be processed by R functions. The workflow is as follows:
1. Initialize a metadata variable environment:
```R
initialise_metadata()
```
2. Assign in your current script R metadata variables as shown earlier or source an external R script:
```R
source("/path/to/metadata/Rfile.R")
```
3. Generate the JSON file:
```R
res = generate_metadata()
```

You can now import this metadata JSON file to a dataverse instance using the `create_datasets()` function mentioned earlier in the [General API Actions](#general-api-actions) section.

#### Metadata Importation
You can retrieve metadata from an existing dataset on dataverse using `get_datasets_metadata()`. This imports the JSON equivalent of the metadata. From here, you can convert this JSON formatting to a R file containing all the R metadata variable using the `convert_metadata()` function:
``` R
dataset_DOI = "doi:10.57745/LNBEGZ"
metadata = get_datasets_metadata(dataset_DOI=dataset_DOI)
convert_metadata(metadata)
```
> ℹ️ Note: Ideally, this R metadata variables file should be directly reusable to create a new dataset, but the numerical information for ordering duplicable metadata is not yet managed. It is still under development. For now, you can manually add this ordering numerical information.


### Workflow Examples
A dedicated repository provides use cases in [dataverseuR_toolbox](https://github.com/super-lou/dataverseuR_toolbox).  
If you need help creating a personal workflow and cannot find what you need in these examples, [open an issue](https://github.com/super-lou/dataverseuR_toolbox/issues).


## FAQ
📬 — **I would like an upgrade / I have a question / Need to reach me**  
Feel free to [open an issue](https://github.com/super-lou/dataverseuR/issues) ! I’m actively maintaining this project, so I’ll do my best to respond quickly.  
I’m also reachable on my institutional INRAE [email](mailto:louis.heraut@inrae.fr?subject=%5BdataverseuR%5D) for more in-depth discussions.

🛠️ — **I found a bug**  
- *Good Solution* : Search the existing issue list, and if no one has reported it, create a new issue !  
- *Better Solution* : Along with the issue submission, provide a minimal reproducible code sample.  
- *Best Solution* : Fix the issue and submit a pull request. This is the fastest way to get a bug fixed.

🚀 — **Want to contribute ?**  
If you don't know where to start, [open an issue](https://github.com/super-lou/dataverseuR/issues).

If you want to try by yourself, why not start by also [opening an issue](https://github.com/super-lou/dataverseuR/issues) to let me know you're working on something ? Then:

- Fork this repository  
- Clone your fork locally and make changes (or even better, create a new branch for your modifications)
- Push to your fork and verify everything works as expected
- Open a Pull Request on GitHub and describe what you did and why
- Wait for review
- For future development, keep your fork updated using the GitHub “Sync fork” functionality or by pulling changes from the original repo (or even via remote upstream if you're comfortable with Git). Otherwise, feel free to delete your fork to keep things tidy ! 

If we’re connected through work, why not reach out via email to see if we can collaborate more closely on this repo by adding you as a collaborator !


## Code of Conduct
Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
