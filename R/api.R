# Copyright 2025 Louis Héraut (louis.heraut@inrae.fr)*1
#
# *1   INRAE, France
#
# This file is part of dataverseur R package.
#
# dataverseur R package is free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# dataverseur R package is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU xGeneral Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with dataverseur R package.
# If not, see <https://www.gnu.org/licenses/>.


#' @title create_dotenv
#' @description Create a default .env file necessary to fill in environment variables required for dataverse authentication.
#' @param dotenv_path A character string for the path of the .env file that will be created. By default, it create a file named `dist.env` in the working directory. This file should be rename `.env`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @return The function returns the path to the created .env file.
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' @examples
#' # Create the .env file to the working directory
#' create_dotenv()
#'
#' # Create the .env file in a remote location with no informations displayed
#' create_dotenv("/path/to/dir/.env-demo", verbose=FALSE)
#' @export
#' @md
create_dotenv = function(dotenv_path=file.path(getwd(), "dist.env"),
                         verbose=TRUE) {
    
    dotenv_from_path = system.file("extdata", "dist.env",
                                   package="dataverseur")
    file.copy(dotenv_from_path, dotenv_path, overwrite=TRUE)

    if (verbose) {
        message(paste0("The '", basename(dotenv_path),
                       "' file has been copied to : '",
                       dotenv_path,
                       "'\n\nPLease fill in your credential and rename that file '.env'.\n/!\\ NEVER give your personnal credential through a GIT repo."))
    }
    return (dotenv_path)
}


search_metadata_blocks = function() {
    search_url = "https://entrepot.recherche.data.gouv.fr/api/metadatablocks/citation"
    # search_url = modify_url(base_url, query=query_params)
    response = httr::GET(search_url)
    
    if (httr::status_code(response) == 200) {
        metadata_blocks = httr::content(response, "parsed")
        return (metadata_blocks)
    } else {
        stop(paste0(httr::status_code(response), " ",
                    httr::content(response, "text")))
    }
}


convert_datasets_to_tibble_hide = function(dataset) {
    dataset_flat = purrr::map(dataset, function(x) {
        if (is.atomic(x)) {
            x
        } else {
      list(x)
        }
    })
    dplyr::as_tibble(dataset_flat) 
}

convert_datasets_search_to_tibble = function (datasets_search) {
    results = dplyr::tibble()
    for (dataset in datasets_search$items) {
        results_tmp = convert_datasets_to_tibble_hide(dataset)
        results = dplyr::bind_rows(results, results_tmp)
    }
    if (nrow(results) > 0) {
        results = dplyr::rename(results, dataset_DOI=global_id)
    }
    return (results)
}


#' @title convert_DOI_to_URL
#' @description Convert a DOI to a functional URL.
#' @param DOI A character string specifying the DOI to convert.
#' @return A character string for the associated URL.
#' @examples
#' convert_DOI_to_URL("doi:10.57745/LNBEGZ")
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' @export
#' @md
convert_DOI_to_URL = function (DOI) {
    URL = gsub("doi[:]",
               "https://doi.org/",
               DOI)
    return (URL)
}


#' @title search_datasets
#' @description Performs a search query on the Dataverse API.
#' @param query A character string specifying the search query. The default value is `"*"` which means a search for all datasets.
#' 
#' More information on search formatting through an example:
#'
#' QUERY TYPE	     SYNTAX EXAMPLE                      DESCRIPTION
#' Basic Search	     query="climate"	                 Finds "climate" anywhere
#' Exact Phrase	     query='"climate change"'	         Finds the exact phrase
#' Wildcard (* & ?)  query="climat*" or query="cl?mate"	 Matches variations
#' Boolean Search    query="climate AND temperature"	 Combines terms
#' Field Search	     query="title:climate"	         Searches specific fields
#' Fuzzy Search	     query="climate~"	                 Finds similar words
#' Proximity Search  query='"climate temperature"~5'	 Finds nearby words
#' Regex (Limited)   query="climate*"                    Limited pattern matching
#' 
#' @param publication_status A character string specifying the publication status of the datasets. Valid options are "DRAFT", "RELEASED". The default is `"*"`, meaning all statuses.
#' @param type A character string specifying the type of object to search between `"dataverse"`, `"dataset"`, or `"file"`. The default is `"dataset"` for searching only dataset.
#' @param dataverse A character string specifying the dataverse to search within. If left empty, the search will query all available dataverses in the `BASE_URL`.
#' @param n_search An integer indicating the maximum number of results to return. Default is 10.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @return A tibble of the restult of the search.
#' @examples
#' \dontrun{
#' # A simple example to search all datasets from a dataverse
#' datasets = search_datasets(query="*",
#'                            publication_status="RELEASED",
#'                            type="dataset",
#'                            dataverse="riverly",
#'                            n_search=1000)
#'
#' # A more difficult one with a complexe query 
#' query = '(title:"Fiches de résultats*" OR title:"Fiches incertitudes*") NOT kindOfDataOther:"Notice"'
#' datasets = search_datasets(query=query,
#'                            publication_status="RELEASED",
#'                            type="dataset",
#'                            dataverse="explore2",
#'                            n_search=1000)
#' }
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' - [R example in context](https://github.com/super-lou/dataverseuR_toolbox/blob/main/Explore2/post_hydrological_projection.R) <https://github.com/super-lou/dataverseuR_toolbox/blob/main/Explore2/post_hydrological_projection.R>
#' - [Search API documentation](https://guides.dataverse.org/en/5.3/api/search.html) <https://guides.dataverse.org/en/5.3/api/search.html>
#' @export
#' @md
search_datasets = function(query="*", publication_status="*",
                           type="dataset", dataverse="",
                           n_search=10,
                           BASE_URL=Sys.getenv("BASE_URL"),
                           API_TOKEN=Sys.getenv("API_TOKEN")) {

    query = gsub("[ ]", "+", query)
    q = paste0(paste0("q=", query), collapse="&")
    if (publication_status == "DRAFT") {
        fq = "fq=publicationStatus:Draft"
    } else if (publication_status == "RELEASED") {
        fq = "fq=publicationStatus:Published"
    } else {
        fq = paste0("fq=", publication_status) 
    }
    
    type = paste0(paste0("type=", type), collapse="&")
    subtree = paste0(paste0("subtree=", dataverse), collapse="&")
    # &metadata_fields=citation:author
    
    search_url = paste0(BASE_URL, "/api/search?",
                        q, "&",
                        fq, "&",
                        type, "&",
                        subtree, "&",
                        "per_page=", n_search)

    response = httr::GET(search_url,
                         httr::add_headers("X-Dataverse-key" = API_TOKEN))
    
    if (httr::status_code(response) != 200) {
        stop(paste0(httr::status_code(response), " ",
                    httr::content(response, "text")))
    }
    datasets = httr::content(response, "parsed")$data
    datasets = convert_datasets_search_to_tibble(datasets)
    return (datasets)
}


# #' @title get_DOI_from_datasets_search
# #' @description This function extracts the DOIs (Digital Object Identifiers) from a dataset object. It takes a list of datasets and returns a named vector where the names correspond to the dataset names and the values correspond to their respective DOIs.
# #' @param datasets_search A dataset object, typically a list or data frame, containing items with `name` and `global_id` attributes, where `global_id` represents the DOI.
# #' @return A named vector where each name is the dataset name and each value is the corresponding DOI.
# #' @examples
# #' # Example dataset with items containing names and global_ids
# #' datasets <- list(items = list(list(name = "Dataset 1", global_id = "10.1234/abc"), 
# #'                               list(name = "Dataset 2", global_id = "10.5678/def")))
# #' get_DOI_from_datasets_search(datasets)
# #' @md
# get_DOI_from_datasets_search = function (datasets_search) {
#     name = sapply(datasets_search$items, function (x) x$name)
#     DOI = sapply(datasets_search$items, function (x) x$global_id)
#     names(DOI) = name
#     return (DOI)
# }


#' @title get_datasets_size
#' @description Retrieves the total storage size (in bytes) of a selection of datasets.
#' @param dataset_DOI A vector of character string representing the DOI of datasets that will be process.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @return A tibble containing datasets DOI and their corresponding total storage sizes in bytes.
#' @export
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' - [R example in context](https://github.com/super-lou/dataverseuR_toolbox/blob/main/RiverLy_HCERES_2025/script.R) <https://github.com/super-lou/dataverseuR_toolbox/blob/main/RiverLy_HCERES_2025/script.R>
#' - [Native API documentation](https://guides.dataverse.org/en/5.3/api/native-api.html#report-the-data-file-size-of-a-dataverse) <https://guides.dataverse.org/en/5.3/api/native-api.html#report-the-data-file-size-of-a-dataverse>
#' @md
get_datasets_size = function(dataset_DOI,
                             BASE_URL=Sys.getenv("BASE_URL"),
                             API_TOKEN=Sys.getenv("API_TOKEN"),
                             verbose=TRUE) {

    results = dplyr::tibble()
    
    nDOI = length(dataset_DOI)
    
    for (i in 1:nDOI) {
        dDOI = dataset_DOI[i]
        
        query_url = paste0(BASE_URL, "/api/datasets/:persistentId/storagesize/?persistentId=", dDOI)
        response = httr::GET(query_url, 
                         httr::add_headers("X-Dataverse-key"=API_TOKEN))
        
        if (httr::status_code(response) == 200) {
            size_value = httr::content(response,
                                       "parsed")$data$message
            size_value = gsub("(.*[:] )|( bytes)|(,)", "",
                              size_value)
            size_value = as.numeric(size_value)
        } else {
            warning(paste0(dDOI, " : ",
                           httr::status_code(response), " ",
                           httr::content(response, "text")))
            size_value = NA
        }
        
        results_tmp = dplyr::tibble(dataset_DOI=dDOI,
                                    storage_size_bytes=size_value)
        results = dplyr::bind_rows(results, results_tmp)

        if (verbose) message(paste0(round(i/nDOI*100, 1), "% : size of dataset ", convert_DOI_to_URL(dDOI), " retrieved"))
    }
    
    results$storage_size_GB = round(results$storage_size_bytes/1024**3, 3)
    return(results)
}



#' @title get_datasets_metrics
#' @description Retrieves dataset metrics of views and downloads from a selection of datasets.
#' @param dataset_DOI A vector of character string representing the DOI of datasets that will be process.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @return A named list containing total views, unique views, total downloads, unique downloads, and citations.
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' - [R example in context](https://github.com/super-lou/dataverseuR_toolbox/blob/main/RiverLy_HCERES_2025/script.R) <https://github.com/super-lou/dataverseuR_toolbox/blob/main/RiverLy_HCERES_2025/script.R>
#' - [Native API documentation](https://guides.dataverse.org/en/5.3/api/native-api.html#dataset-metrics) <https://guides.dataverse.org/en/5.3/api/native-api.html#dataset-metrics>
#' @export
#' @md
get_datasets_metrics = function(dataset_DOI,
                                BASE_URL=Sys.getenv("BASE_URL"),
                                API_TOKEN=Sys.getenv("API_TOKEN"),
                                verbose=TRUE) {

    results = dplyr::tibble()
    metrics = c("viewsTotal", "viewsUnique",
                "downloadsTotal", "downloadsUnique") #"citations"

    nDOI = length(dataset_DOI)
    
    for (i in 1:nDOI) {
        dDOI = dataset_DOI[i]
                    
        results_tmp = c()
        for (metric in metrics) {
            query_url = paste0(BASE_URL, "/api/datasets/:persistentId/makeDataCount/", 
                               metric, "?persistentId=", dDOI)
            
            response = httr::GET(query_url, 
                                 httr::add_headers("X-Dataverse-key"=API_TOKEN))
            
            if (httr::status_code(response) == 200) {
                metric_value = unlist(httr::content(response,
                                                    "parsed")$data)
            } else {
                warning(paste0(dDOI, " - ", metric, " : ",
                               httr::status_code(response), " ",
                               httr::content(response, "text")))
                metric_value = NA
            }
            results_tmp = c(results_tmp, metric_value)
        }
        # results_tmp = as.numeric(results_tmp)
        results_tmp = c(dataset_DOI=dDOI, results_tmp)
        results_tmp = dplyr::tibble(!!!results_tmp)
        results = dplyr::bind_rows(results, results_tmp)

        if (verbose) message(paste0(round(i/nDOI*100, 1), "% : metrics for dataset ", convert_DOI_to_URL(dDOI), " retrieved"))
    }
    
    results = dplyr::mutate(results,
                            dplyr::across(.cols=metrics,
                                          .fns=as.numeric))
    return (results)
}



#' @title create_datasets
#' @description Create new datasets in a specified dataverse for a selection of metadata json file. See [generate_metadata()] in order to generate efficiently metadata json file.
#' @param dataverse A character string specifying the name of the dataverse in which to create datasets.
#' @param metadata_path A vector of character string for the paths of json files containing the datasets metadata.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @return The function returns DOI of the newly created datasets as a vector of character string.
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' - [R example in context](https://github.com/super-lou/dataverseuR_toolbox/blob/main/Explore2/post_hydrological_projection.R) <https://github.com/super-lou/dataverseuR_toolbox/blob/main/Explore2/post_hydrological_projection.R>
#' - [Native API documentation](https://guides.dataverse.org/en/5.3/api/native-api.html#create-a-dataset-in-a-dataverse) <https://guides.dataverse.org/en/5.3/api/native-api.html#create-a-dataset-in-a-dataverse>
#' @export
#' @md
create_datasets = function(dataverse,
                           metadata_path,
                           BASE_URL=Sys.getenv("BASE_URL"),
                           API_TOKEN=Sys.getenv("API_TOKEN"),
                           verbose=TRUE) {

    dataset_DOI = c()
    nDOI = length(metadata_path)
    
    for (i in 1:nDOI) {
        mpath = metadata_path[i]
        
        mjson = jsonlite::fromJSON(mpath,
                                   simplifyDataFrame=FALSE,
                                   simplifyVector=FALSE)

        create_url = paste0(BASE_URL, "/api/dataverses/",
                            dataverse, "/datasets")
        response = httr::POST(create_url,
                              httr::add_headers("X-Dataverse-key"=API_TOKEN),
                              body = mjson,
                              encode = "json") 

        if (httr::status_code(response) != 201) {
            stop(paste0(httr::status_code(response), " ",
                        httr::content(response, "text")))
        }

        dataset = httr::content(response, "parsed")
        dDOI = dataset$data$persistentId
        dataset_DOI = c(dataset_DOI, dDOI)

        if (verbose) message(paste0(round(i/nDOI*100, 1), "% : dataset ", convert_DOI_to_URL(dDOI), " created"))
    }
    return (dataset_DOI)
}


#' @title get_datasets_metadata
#' @description Retrieves metadata for a selection of dataset. See [convert_metadata()] in order to convert metadata extracted by this function to R parameterisation file.
#' @param dataset_DOI A vector of character string representing the DOI of datasets that will be process.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @return A list containing the datasets metadata.
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' - [R example in context](https://github.com/super-lou/dataverseuR_toolbox/blob/main/Explore2/post_hydrological_projection.R) <https://github.com/super-lou/dataverseuR_toolbox/blob/main/Explore2/post_hydrological_projection.R>
#' - [Native API documentation](https://guides.dataverse.org/en/5.3/api/native-api.html#get-json-representation-of-a-dataset) <https://guides.dataverse.org/en/5.3/api/native-api.html#get-json-representation-of-a-dataset>
#' @export
#' @md
get_datasets_metadata = function(dataset_DOI,
                                 BASE_URL=Sys.getenv("BASE_URL"),
                                 API_TOKEN=Sys.getenv("API_TOKEN"),
                                 verbose=TRUE) {

    metadata_list = list()
    nDOI = length(dataset_DOI)
    
    for (i in 1:nDOI) {
        dDOI = dataset_DOI[i]

        api_url = paste0(BASE_URL, "/api/datasets/:persistentId/?persistentId=", dDOI)
        response = httr::GET(api_url, httr::add_headers("X-Dataverse-key"=API_TOKEN))
        
        if (httr::status_code(response) != 200) {
            stop(paste0(httr::status_code(response), " ",
                        httr::content(response, "text")))
        }

        response_content = httr::content(response, as="text",
                                         encoding="UTF-8")
        dataset = jsonlite::fromJSON(response_content,
                                     simplifyDataFrame=FALSE,
                                     simplifyVector=TRUE)
        metadata = dataset$data[c("metadataLanguage",
                                  "latestVersion")]
        if (nDOI == 1) {
            metadata_list = metadata
        } else {
            metadata_list = append(metadata_list, list(metadata))
            names(metadata_list)[i] = dDOI
        }
        
        if (verbose) message(paste0(round(i/nDOI*100, 1), "% : dataset metadata ", convert_DOI_to_URL(dDOI), " retrieved"))
    }
    return (metadata_list)
}


#' @title modify_datasets
#' @description Modify datasets metadata from a selection of metadata json file. See [generate_metadata()] in order to generate efficiently metadata json file.
#' @param dataverse A character string specifying the name of the dataverse in which to create datasets.
#' @param dataset_DOI A vector of character string representing the DOI of datasets that will be process.
#' @param metadata_path A vector of character string for the paths of json files containing the datasets metadata.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' - [R example in context](https://github.com/super-lou/dataverseuR_toolbox/blob/main/Explore2/post_hydrological_projection.R) <https://github.com/super-lou/dataverseuR_toolbox/blob/main/Explore2/post_hydrological_projection.R>
#' - [Native API documentation](https://guides.dataverse.org/en/5.3/api/native-api.html#update-metadata-for-a-dataset) <https://guides.dataverse.org/en/5.3/api/native-api.html#update-metadata-for-a-dataset>
#' @export
#' @md
modify_datasets = function(dataverse,
                           dataset_DOI,
                           metadata_path,
                           BASE_URL=Sys.getenv("BASE_URL"),
                           API_TOKEN=Sys.getenv("API_TOKEN"),
                           verbose=TRUE) {

    nDOI = length(dataset_DOI)
    
    for (i in 1:nDOI) {
        dDOI = dataset_DOI[i]
        mpath = metadata_path[i]
        
        mjson = jsonlite::fromJSON(mpath,
                                   simplifyDataFrame=FALSE,
                                   simplifyVector=FALSE)
        modify_url = paste0(BASE_URL,
                            "/api/datasets/:persistentId/versions/:draft?persistentId=",
                            dDOI)

        response = httr::PUT(modify_url,
                             httr::add_headers("X-Dataverse-key"=API_TOKEN),
                             body=mjson$datasetVersion,
                             encode="json")

        if (httr::status_code(response) != 200) {
            stop(paste0(httr::status_code(response), " ",
                        httr::content(response, "text")))
        }

        if (verbose) message(paste0(round(i/nDOI*100, 1), "% : dataset ", convert_DOI_to_URL(dDOI), " modified"))
    }
}


#' @title add_datasets_files
#' @description This function uploads files to a dataset.
#' @param dataset_DOI A vector of character string representing the DOI of datasets that will be process.
#' @param file_paths A vector of character string of paths of the files that needs to be uploaded. If you want to conserve a directory structure, set the name of each file path to the directory name wanted. If `dataset_DOI` contains more than one dataset DOI, `file_paths` needs to be a list of vector of character string, each vector of this list will be associated to each dataset identified in `dataset_DOI`.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @return A character vector containing the paths of the files that could not be uploaded, if any.
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' - [R example in context](https://github.com/super-lou/dataverseuR_toolbox/blob/main/Explore2/post_hydrological_projection.R) <https://github.com/super-lou/dataverseuR_toolbox/blob/main/Explore2/post_hydrological_projection.R>
#' - [Native API documentation](https://guides.dataverse.org/en/5.3/api/native-api.html#add-a-file-to-a-dataset) <https://guides.dataverse.org/en/5.3/api/native-api.html#add-a-file-to-a-dataset>
#' @export
#' @md
add_datasets_files = function(dataset_DOI, file_paths,
                              BASE_URL=Sys.getenv("BASE_URL"),
                              API_TOKEN=Sys.getenv("API_TOKEN"),
                              verbose=TRUE) {

    if (!is.list(file_paths)) {
        file_paths = list(file_paths)
    }

    not_added = list()
    nDOI = length(dataset_DOI)
    
    for (i in 1:nDOI) {
        dDOI = dataset_DOI[i]
        if (verbose) message(paste0(round(i/nDOI*100, 1), "% : files addition for dataset ", convert_DOI_to_URL(dDOI)))
        
        url = paste0(BASE_URL,
                     '/api/datasets/:persistentId/add?persistentId=',
                     dDOI)

        not_added_tmp = c()
        nFiles = length(file_paths[[i]])
        
        for (j in 1:nFiles) {
            file_path = file_paths[[i]][j]
            directory_label = names(file_paths[[i]])[j]
            
            if (is.null(directory_label)) {
                directory_label = ""
            }
            json_data = list(
                description = "",
                directoryLabel = directory_label,
                restrict = "false",
                tabIngest = "true"
            )
            response =
                httr::POST(url,
                           httr::add_headers("X-Dataverse-key" = API_TOKEN),
                           body=list(
                               file = httr::upload_file(file_path),
                               jsonData=I(jsonlite::toJSON(json_data, auto_unbox=TRUE))
                           ),
                           encode="multipart")
            
            if (httr::status_code(response) != 200) {
                not_added_tmp = c(not_added_tmp, file_path)
                names(not_added_tmp)[length(not_added_tmp)] = j
                warning(paste0("file ", j, " : ", file_path, "\n",
                               httr::status_code(response), " ",
                               httr::content(response, "text")))
            }
            if (verbose) message(paste0(" - ", round(j/nFiles*100, 1), "% : file ", file_path, " added"))
        }
        not_added = append(not_added, list(not_added_tmp))
    }
    return (not_added)
}


#' @title list_datasets_files
#' @description Retrieves files informations of a selection of datasets.
#' @param dataset_DOI A vector of character string representing the DOI of datasets that will be process.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @return A [tibble][dplyr::tibble()] containing files information.
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' - [R example in context](https://github.com/super-lou/dataverseuR_toolbox/blob/main/DRYvER/modify_README.R) <https://github.com/super-lou/dataverseuR_toolbox/blob/main/DRYvER/modify_README.R>
#' -  [Native API documentation](https://guides.dataverse.org/en/5.3/api/native-api.html#list-files-in-a-dataset) <https://guides.dataverse.org/en/5.3/api/native-api.html#list-files-in-a-dataset>
#' @export
#' @md
list_datasets_files = function(dataset_DOI,
                               BASE_URL=Sys.getenv("BASE_URL"),
                               API_TOKEN=Sys.getenv("API_TOKEN")) {

    files = dplyr::tibble()
    nDOI = length(dataset_DOI)
    
    for (i in 1:nDOI) {
        dDOI = dataset_DOI[i]
        
        api_url = paste0(BASE_URL,
                         "/api/datasets/:persistentId/?persistentId=",
                         dDOI)
        response = httr::GET(api_url,
                             httr::add_headers("X-Dataverse-key"=API_TOKEN))

        if (httr::status_code(response) != 200) {
            stop(paste0(httr::status_code(response), " ",
                        httr::content(response, "text")))
        }
        
        response_content = httr::content(response, as="text",
                                         encoding="UTF-8")
        dataset_info = jsonlite::fromJSON(response_content)
        files_tmp = dataset_info$data$latestVersion$files
        if ("description" %in% names(files_tmp)) {
            files_tmp = dplyr::select(files_tmp, -description)
        }
        if ("categories" %in% names(files_tmp$dataFile)) {
            files_tmp$dataFile = dplyr::select(files_tmp$dataFile, -categories)
        }
        files_tmp = tidyr::unnest(files_tmp, cols=c(dataFile))
        files_tmp = dplyr::rename(files_tmp, file_DOI=persistentId)
        files_tmp$dataset_DOI = dDOI
        files_tmp = dplyr::relocate(files_tmp, dataset_DOI,
                                    .before=dplyr::everything())
        
        files = dplyr::bind_rows(files, files_tmp)
    }
    return (files)
}


#' @title rename_datasets_files
#' @description Renames a file based on their DOI.
#' @param file_DOI A vector of character string of the DOI of files to be processed.
#' @param new_name A vector of character string representing the new filename.
#' @param is_DOI_ID If the dataset is not published yet, the DOI of the file does not exist, so `file_DOI` needs to be the file id of the database instead of a DOI. So if `TRUE`, `file_DOI` is `id` from the results of [list_datasets_files()], elsewhere if `FALSE`, `file_DOI` is actual file DOI. Default, `FALSE`.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If `FALSE`, no processing informations are displayed. By default, `TRUE`.
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' - [R example in context](https://github.com/super-lou/dataverseuR_toolbox/blob/main/Explore2/post_hydrological_projection.R) <https://github.com/super-lou/dataverseuR_toolbox/blob/main/Explore2/post_hydrological_projection.R>
#' - [Native API documentation](https://guides.dataverse.org/en/5.3/api/native-api.html#updating-file-metadata) <https://guides.dataverse.org/en/5.3/api/native-api.html#updating-file-metadata>
#' @export
#' @md
rename_datasets_files = function(file_DOI, new_name,
                                 is_DOI_ID=FALSE,
                                 BASE_URL=Sys.getenv("BASE_URL"),
                                 API_TOKEN=Sys.getenv("API_TOKEN"),
                                 verbose=TRUE) {

    nFiles = length(file_DOI)
    
    for (i in 1:nFiles) {
        fDOI = file_DOI[i]
        label = new_name[i]

        if (is_DOI_ID) {
            api_url = paste0(BASE_URL, "/api/files/", fDOI, "/metadata")
        } else {
            api_url = paste0(BASE_URL, "/api/files/:persistentId/metadata?persistentId=", fDOI)
        }
        
        json_body = jsonlite::toJSON(list(label=label), auto_unbox=TRUE)
        
        response = httr::POST(url=api_url,
                              httr::add_headers("X-Dataverse-key"=API_TOKEN),
                              body=list(jsonData=json_body),
                              encode="multipart")
        
        if (httr::status_code(response) != 200) {
            stop(paste0(httr::status_code(response), " ",
                        httr::content(response, "text")))
        }
        if (verbose) message(paste0(round(i/nFiles*100, 1), "% : file ", convert_DOI_to_URL(fDOI), " renamed"))
    }
}


#' @title download_datasets_files
#' @description Download files based on their DOI.
#' @param file_DOI A vector of character string of the DOI of files to be processed.
#' @param save_paths A vector of character string representing the local path where files should be saved.
#' @param is_DOI_ID If the dataset is not published yet, the DOI of the file does not exist, so `file_DOI` needs to be the file id of the database instead of a DOI. So if `TRUE`, `file_DOI` is `id` from the results of [list_datasets_files()], elsewhere if `FALSE`, `file_DOI` is actual file DOI. Default, `FALSE`.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' - [R example in context](https://github.com/super-lou/dataverseuR_toolbox/blob/main/DRYvER/modify_README.R) <https://github.com/super-lou/dataverseuR_toolbox/blob/main/DRYvER/modify_README.R>
#' - [Native API documentation](https://guides.dataverse.org/en/5.3/api/native-api.html#accessing-downloading-files) <https://guides.dataverse.org/en/5.3/api/native-api.html#accessing-downloading-files>
#' @export
#' @md
download_datasets_files = function(file_DOI,
                                   save_paths,
                                   is_DOI_ID=FALSE,
                                   BASE_URL=Sys.getenv("BASE_URL"),
                                   API_TOKEN=Sys.getenv("API_TOKEN"),
                                   verbose=TRUE) {

    nFiles = length(file_DOI)
    
    for (i in 1:nFiles) {
        fDOI = file_DOI[i]
        save_path = save_paths[i]

        if (is_DOI_ID) {
            api_url = paste0(BASE_URL, "/api/access/datafile/", fDOI)
        } else {
            api_url = paste0(BASE_URL, "/api/access/datafile/:persistentId/?persistentId=", fDOI)
        }
        
        response = httr::GET(api_url, 
                             httr::add_headers("X-Dataverse-key"=API_TOKEN),
                             httr::write_disk(save_path, overwrite=TRUE))
        
        if (httr::status_code(response) != 200) {
            stop(paste0(httr::status_code(response), " ",
                        httr::content(response, "text")))
        }
        if (verbose) message(paste0(round(i/nFiles*100, 1), "% : file ", convert_DOI_to_URL(fDOI), " saved in ", save_path))
    }
}


#' @title delete_datasets_files
#' @description Delete files based on their DOI.
#' @param file_DOI A vector of character string of the DOI of files to be processed.
#' @param is_DOI_ID If the dataset is not published yet, the DOI of the file does not exist, so `file_DOI` needs to be the file id of the database instead of a DOI. So if `TRUE`, `file_DOI` is `id` from the results of [list_datasets_files()], elsewhere if `FALSE`, `file_DOI` is actual file DOI. Default, `FALSE`.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' - [R example in context](https://github.com/super-lou/dataverseuR_toolbox/blob/main/DRYvER/modify_README.R) <https://github.com/super-lou/dataverseuR_toolbox/blob/main/DRYvER/modify_README.R>
#' - [Native API documentation](https://guides.dataverse.org/en/5.3/api/native-api.html#files) <https://guides.dataverse.org/en/5.3/api/native-api.html#files>
#' @export
#' @md
delete_datasets_files = function(file_DOI,
                                 is_DOI_ID=FALSE,
                                 BASE_URL=Sys.getenv("BASE_URL"),
                                 API_TOKEN=Sys.getenv("API_TOKEN"),
                                 verbose=TRUE) {

    nFiles = length(file_DOI)
    
    for (i in 1:nFiles) {
        fDOI = file_DOI[i]

        if (is_DOI_ID) {
            delete_url = paste0(BASE_URL, "/api/files/", fDOI)
        } else {
            delete_url = paste0(BASE_URL, "/api/files/:persistentId/?persistentId=", fDOI)
        }
        
        response = httr::DELETE(delete_url,
                                httr::add_headers("X-Dataverse-key"=API_TOKEN))
        
        if (httr::status_code(response) != 200) {
            stop(paste0(httr::status_code(response), " ",
                        httr::content(response, "text")))
        }
        if (verbose) message(paste0(round(i/nFiles*100, 1), "% : file ", convert_DOI_to_URL(fDOI), " deleted"))
    }
}


#' @title delete_all_datasets_files
#' @description Delete all files from a selection of datasets.
#' @param dataset_DOI A vector of character string representing the DOI of datasets that will be process.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' - [R example in context](https://github.com/super-lou/dataverseuR_toolbox/blob/main/Explore2/post_hydrological_projection.R) <https://github.com/super-lou/dataverseuR_toolbox/blob/main/Explore2/post_hydrological_projection.R>
#' - [Native API documentation](https://guides.dataverse.org/en/5.3/api/native-api.html#files) <https://guides.dataverse.org/en/5.3/api/native-api.html#files>
#' @export
#' @md
delete_all_datasets_files = function(dataset_DOI,
                                     BASE_URL=Sys.getenv("BASE_URL"),
                                     API_TOKEN=Sys.getenv("API_TOKEN"),
                                     verbose=TRUE) {

    nDOI = length(dataset_DOI)
    
    for (i in 1:nDOI) {
        dDOI = dataset_DOI[i]
        if (verbose) message(paste0(round(i/nDOI*100, 1), "% : files deletion for dataset ", convert_DOI_to_URL(dDOI)))
        
        files = list_dataset_files(dataset_DOI=dDOI,
                                   BASE_URL=BASE_URL,
                                   API_TOKEN=API_TOKEN)
        nFiles = nrow(files)
        
        for (j in 1:nFiles) {
            file = files[j, ]
            fDOI = file$file_DOI
            
            delete_dataset_file(file_DOI=fDOI,
                                BASE_URL=BASE_URL,
                                API_TOKEN=API_TOKEN,
                                verbose=FALSE)

            if (verbose) message(paste0(" - ", round(j/nFiles*100, 1), "% : file ", convert_DOI_to_URL(fDOI), " deleted"))
            
            # delete_url = paste0(BASE_URL, "/api/files/", file_id)
            # response = httr::DELETE(delete_url,
            # httr::add_headers("X-Dataverse-key"=API_TOKEN))
            
            # if (httr::status_code(response) == 200) {
            # print(paste0(i, ": ", file$id, " -> ok"))
            # } else {
            # print(paste0(i, ": ", file$id, " -> error ",
            # httr::status_code(response), " ",
            # httr::content(response, "text")))
            # }
        }
    }
}


#' @title publish_datasets
#' @description Publish a selection of datasets.
#' @param dataset_DOI A vector of character string representing the DOI of datasets that will be process.
#' @param type A character string specifying the type of publication. Use `"major"` if at least a file as been modified of supressed, if only metadata have changed, use `"minor"`.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' - [R example in context](https://github.com/super-lou/dataverseuR_toolbox/blob/main/Explore2/post_hydrological_projection.R) <https://github.com/super-lou/dataverseuR_toolbox/blob/main/Explore2/post_hydrological_projection.R>
#' - [Native API documentation](https://guides.dataverse.org/en/5.3/api/native-api.html#publish-a-dataset) <https://guides.dataverse.org/en/5.3/api/native-api.html#publish-a-dataset>
#' @export
#' @md
publish_datasets = function(dataset_DOI, type="major",
                            BASE_URL=Sys.getenv("BASE_URL"),
                            API_TOKEN=Sys.getenv("API_TOKEN"),
                            verbose=TRUE) {

    nDOI = length(dataset_DOI)

    for (i in 1:nDOI) {
        dDOI = dataset_DOI[i]
        
        publish_url = paste0(BASE_URL, "/api/datasets/:persistentId/actions/:publish?persistentId=",
                             dDOI, "&type=", type)
        response = httr::POST(publish_url,
                              httr::add_headers("X-Dataverse-key"=API_TOKEN))
        
        if (httr::status_code(response) != 200) {
            stop(paste0(httr::status_code(response), " ",
                        httr::content(response, "text")))
        }
        if (verbose) message(paste0(round(i/nDOI*100, 1), "% : dataset ", convert_DOI_to_URL(dDOI), " published"))
    }
}


#' @title delete_datasets
#' @description Delete a selection of unpublished datasets.
#' @param dataset_DOI A vector of character string representing the DOI of datasets that will be process.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' - [R example in context](https://github.com/super-lou/dataverseuR_toolbox/blob/main/Explore2/post_hydrological_projection.R) <https://github.com/super-lou/dataverseuR_toolbox/blob/main/Explore2/post_hydrological_projection.R>
#' - [Native API documentation](https://guides.dataverse.org/en/5.3/api/native-api.html#delete-unpublished-dataset) <https://guides.dataverse.org/en/5.3/api/native-api.html#delete-unpublished-dataset>
#' @export
#' @md
delete_datasets = function(dataset_DOI,
                           BASE_URL=Sys.getenv("BASE_URL"),
                           API_TOKEN=Sys.getenv("API_TOKEN"),
                           verbose=TRUE) {
    
    nDOI = length(dataset_DOI)

    for (i in 1:nDOI) {
        dDOI = dataset_DOI[i]
        
        delete_url = paste0(BASE_URL, "/api/datasets/:persistentId/?persistentId=", dDOI)
        response = httr::DELETE(delete_url,
                                httr::add_headers("X-Dataverse-key"=API_TOKEN))
        
        if (httr::status_code(response) != 200) {
            warning(paste0(httr::status_code(response), " ",
                           httr::content(response, "text")))
        }
        if (verbose) message(paste0(round(i/nDOI*100, 1), "% : dataset ", convert_DOI_to_URL(dDOI), " deleted"))
    }
}
