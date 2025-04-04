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
and a `dist.env` file will be created in your working directory. The following step is to fill in your credential.\\
For that, go to your dataverse instance and create a token. For example, for the demo Recherche Data Gouv instance of `BASE_URL` : [https://demo.recherche.data.gouv.fr](https://demo.recherche.data.gouv.fr) click on your account name, find the [API token tab](https://demo.recherche.data.gouv.fr/dataverseuser.xhtml?selectTab=apiTokenTab) and copy your token to the `API_TOKEN` variable in the `dist.env` file like
``` R
# .env

API_TOKEN=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
BASE_URL=https://demo.recherche.data.gouv.fr

```
Then, rename the file `.env` and if you are in a git project, add `.env` to your `.gitignore` file.\\

Now you should be able to use the API without issue by running this line in your working directory :
``` R
dotenv::load_dot_env()
```


### API actions
You can find the entire API documentation [here](https://guides.dataverse.org/en/latest/api/index.html). Obviously not all API actions have been convert to R function, only a small subset are in order to simplify global use of the package. If you need an other function, take to time to create it and open a pull request or create an issue.\\

Below is a list of all the possible API actions.\\

#### For general API actions
- `search_datasets` to perform a search on dataverse
```R
# Find all the published dataset that contain the word climate in their title 
datasets = search_datasets(query="title:'climate'",
                           publication_status="RELEASED",
                           type="dataset",
                           dataverse="",
                           n_search=1000)
# that return
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

- `create_datasets` to create datasets
```R
initialise_metadata()
source(metadata_path)
res = generate_metadata()
dataset_DOI = create_datasets(dataverse="",
                              metadata_path=res$metadata_path)
```
See more information about the metadata creation in (this section)[#metadata-generation].\\
See the documentation of each function for more explaination but they are quite self explanatory.\\

- `modify_datasets` to modify datasets metadata
- `add_datasets_files` to add files to datasets 
- `delete_datasets_files` to delete files from datasets
- `delete_all_datasets_files` to delete all files from datasets
- `publish_datasets` to publish datasets
- `delete_datasets` to delete datasets

#### For information about datasets
- `get_datasets_metadata` to get the metadata list of datasets
- `list_datasets_files` to list files of datasets
- `download_datasets_files` to download files of datasets
- `get_datasets_size` to get the size of datasets
- `get_datasets_metrics` to get the metrics about datasets

#### Others
- `convert_DOI_to_URL` to convert a DOI to an URL


### Metadata generation



### Workflow exmaples
An entire repository is dedicating to use case in [dataverseuR_toolbox](https://github.com/super-lou/dataverseuR_toolbox).\\
If you need help to create a personal workflow and you don't find what you need in those examples, [open an issue](https://github.com/super-lou/dataverseuR_toolbox/issues).


## Help
You can find an interactive help on the website if you press the bottom right interrogation button.


## FAQ
*I have a question.*

-   **Solution**: Search existing issue list and if no one has a similar question create a new issue.

*I found a bug.*

-   **Good Solution**: Search existing issue list and if no one has reported it create a new issue.
-   **Better Solution**: Along with issue submission provide a minimal reproducible example of the bug.
-   **Best Solution**: Fix the issue and submit a pull request. This is the fastest way to get a bug fixed.


## Code of Conduct
Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
