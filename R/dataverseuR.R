#' @name dataverseuR
#' @title dataverseuR
#' @description A dataverse API wraper to enhance deposit procedure with only R variables declaration.
#' 
#' @details See [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR> for an easier approach.
#'
#' @author
#' Main Developer and Maintainer
#' - Louis Héraut <louis.heraut@inrae.fr> INRAE, UR RiverLy, Villeurbanne, France
#'   ORCID : 0009-0006-4372-0923
#' 
#' @seealso
#' To start :
#' - [create_dotenv()] for creating the environment file for credential
#'
#' For metadata generation :
#' - [initialise_metadata()] to initialise a R variable metadata environment
#' - [generate_metadata()] to generate a metadata json file from a R variable metadata environment
#' - [convert_metadata()] to convert a metadata list from a json file to a R variable parameterization file
#' 
#' For general API actions :
#' - [search_datasets()] to perform a search on dataverse
#' - [create_datasets()] to create datasets
#' - [modify_datasets()] to modify datasets metadata
#' - [add_datasets_files()] to add files to datasets 
#' - [delete_datasets_files()] to delete files from datasets
#' - [delete_all_datasets_files()] to delete all files from datasets
#' - [publish_datasets()] to publish datasets
#' - [delete_datasets()] to delete datasets
#'
#' For information about datasets :
#' - [get_datasets_metadata()] to get the metadata list of datasets
#' - [list_datasets_files()] to list files of datasets
#' - [download_datasets_files()] to download files of datasets
#' - [get_datasets_size()] to get the size of datasets
#' - [get_datasets_metrics()] to get the metrics about datasets
#'
#' Others :
#' - [convert_DOI_to_URL()] to convert a DOI to an URL
#' @md
NULL
