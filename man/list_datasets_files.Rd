% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{list_datasets_files}
\alias{list_datasets_files}
\title{list_datasets_files}
\usage{
list_datasets_files(
  dataset_DOI,
  BASE_URL = Sys.getenv("BASE_URL"),
  API_TOKEN = Sys.getenv("API_TOKEN")
)
}
\arguments{
\item{dataset_DOI}{A vector of character string representing the DOI of datasets that will be process.}

\item{BASE_URL}{A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable \code{BASE_URL}.}

\item{API_TOKEN}{A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable \code{API_TOKEN}.}
}
\value{
A \link[dplyr:reexports]{tibble} containing files information.
}
\description{
Retrieves files informations of a selection of datasets.
}
\seealso{
\itemize{
\item \href{https://github.com/super-lou/dataverseuR}{dataverseuR GitHub documentation} \url{https://github.com/super-lou/dataverseuR}
\item \href{https://github.com/super-lou/dataverseuR_toolbox/blob/main/DRYvER/modify_README.R}{R example in context} \url{https://github.com/super-lou/dataverseuR_toolbox/blob/main/DRYvER/modify_README.R}
\item \href{https://guides.dataverse.org/en/5.3/api/native-api.html#list-files-in-a-dataset}{Native API documentation} \url{https://guides.dataverse.org/en/5.3/api/native-api.html#list-files-in-a-dataset}
}
}
