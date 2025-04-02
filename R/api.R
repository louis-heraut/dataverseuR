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
    results = dplyr::rename(results, dataset_DOI=global_id)
    return (results)
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
#' a
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

    # cols = c("dataset_DOI",
    #          "url",
    #          "name",
    #          "citation",
    #          "description",
    #          "identifier_of_dataverse",
    #          "subjects",
    #          "keywords",
    #          "fileCount",
    #          "createdAt",
    #          "authors")
    
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
#' @param datasets_DOI A vector of character string representing the DOI of datasets that will be process.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @return A tibble containing datasets DOI and their corresponding total storage sizes in bytes.
#' @examples
#' a
#' @export
#' @md
get_datasets_size = function(datasets_DOI,
                             BASE_URL=Sys.getenv("BASE_URL"),
                             API_TOKEN=Sys.getenv("API_TOKEN"),
                             verbose=TRUE) {

    results = dplyr::tibble()
    
    N = length(datasets_DOI)
    
    if (verbose) {pb = txtProgressBar(min=0, max=N, style=3)}
    for (i in 1:N) {
        if (verbose) setTxtProgressBar(pb, i)
        
        dataset_DOI = datasets_DOI[i]
        
        query_url = paste0(BASE_URL, "/api/datasets/:persistentId/storagesize/?persistentId=", dataset_DOI)
        response = httr::GET(query_url, 
                         httr::add_headers("X-Dataverse-key"=API_TOKEN))
        
        if (httr::status_code(response) == 200) {
            size_value = httr::content(response,
                                       "parsed")$data$message
            size_value = gsub("(.*[:] )|( bytes)|(,)", "",
                              size_value)
            size_value = as.numeric(size_value)
        } else {
            warning(paste0(dataset_DOI, " : ",
                           httr::status_code(response), " ",
                           httr::content(response, "text")))
            size_value = NA
        }
        
        results_tmp = dplyr::tibble(dataset_DOI=dataset_DOI,
                                    storage_size_bytes=size_value)
        results = dplyr::bind_rows(results, results_tmp)
    }
    if (verbose) close(pb)
    
    results$storage_size_GB = round(results$storage_size_bytes/1024**3, 3)
    return(results)
}



#' @title get_datasets_metrics
#' @description Retrieves dataset metrics of views and downloads from a selection of datasets.
#' @param datasets_DOI A vector of character string representing the DOI of datasets that will be process.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @return A named list containing total views, unique views, total downloads, unique downloads, and citations.
#' @examples
#' a
#' @export
#' @md
get_datasets_metrics = function(datasets_DOI,
                                BASE_URL=Sys.getenv("BASE_URL"),
                                API_TOKEN=Sys.getenv("API_TOKEN"),
                                verbose=TRUE) {

    results = dplyr::tibble()
    metrics = c("viewsTotal", "viewsUnique",
                "downloadsTotal", "downloadsUnique") #"citations"

    N = length(datasets_DOI)
    
    if (verbose) {pb = txtProgressBar(min=0, max=N, style=3)}
    for (i in 1:N) {
        if (verbose) setTxtProgressBar(pb, i)
        
        dataset_DOI = datasets_DOI[i]
                    
        results_tmp = c()
        for (metric in metrics) {
            query_url = paste0(BASE_URL, "/api/datasets/:persistentId/makeDataCount/", 
                               metric, "?persistentId=", dataset_DOI)
            
            response = httr::GET(query_url, 
                                 httr::add_headers("X-Dataverse-key"=API_TOKEN))
            
            if (httr::status_code(response) == 200) {
                metric_value = unlist(httr::content(response,
                                                    "parsed")$data)
            } else {
                warning(paste0(dataset_DOI, " - ", metric, " : ",
                               httr::status_code(response), " ",
                               httr::content(response, "text")))
                metric_value = NA
            }
            results_tmp = c(results_tmp, metric_value)
        }
        # results_tmp = as.numeric(results_tmp)
        results_tmp = c(dataset_DOI=dataset_DOI, results_tmp)
        results_tmp = dplyr::tibble(!!!results_tmp)
        results = dplyr::bind_rows(results, results_tmp)
    }
    if (verbose) close(pb)
    
    results = dplyr::mutate(results,
                            dplyr::across(.cols=metrics,
                                          .fns=as.numeric))
    return (results)
}



#' @title create_datasets
#' @description Create new datasets in a specified dataverse for a selection of metadata json file. See [generate_metadata()] in order to generate efficiently metadata json file.
#' @param dataverse A character string specifying the name of the dataverse in which to create datasets.
#' @param metadata_paths A vector of character string for the paths of json files containing the datasets metadata.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @return The function returns DOI of the newly created datasets as a vector of character string.
#' @examples
#' a
#' @export
#' @md
create_datasets = function(dataverse,
                           metadata_paths,
                           BASE_URL=Sys.getenv("BASE_URL"),
                           API_TOKEN=Sys.getenv("API_TOKEN"),
                           verbose=TRUE) {

    datasets_DOI = c()
    N = length(metadata_paths)
    
    if (verbose) {pb = txtProgressBar(min=0, max=N, style=3)}
    for (i in 1:N) {
        if (verbose) setTxtProgressBar(pb, i)
        
        metadata_path = metadata_paths[i]
        
        metadata_json = jsonlite::fromJSON(metadata_path,
                                           simplifyDataFrame=FALSE,
                                           simplifyVector=FALSE)

        create_url = paste0(BASE_URL, "/api/dataverses/",
                            dataverse, "/datasets")
        response = httr::POST(create_url,
                              httr::add_headers("X-Dataverse-key"=API_TOKEN),
                              body = metadata_json,
                              encode = "json") 

        if (httr::status_code(response) != 201) {
            stop(paste0(httr::status_code(response), " ",
                        httr::content(response, "text")))
        }

        dataset_info = httr::content(response, "parsed")
        dataset_DOI = dataset_info$data$persistentId
        dataset_DOI_URL = gsub("doi[:]",
                               "https://doi.org/",
                               dataset_DOI)
        if (verbose) {
            message(paste0("Dataset of DOI ", dataset_DOI,
                           " has been created in ",
                           BASE_URL, "/dataverse/",
                           dataverse, " at ", dataset_DOI_URL))
        }
        datasets_DOI = c(datasets_DOI, dataset_DOI)
    }
    if (verbose) close(pb)
    return (datasets_DOI)
}


#' @title get_datasets_metadata
#' @description Retrieves metadata for a selection of dataset. See [convert_metadata()] in order to convert metadata extracted by this function to R parameterisation file.
#' @param datasets_DOI A vector of character string representing the DOI of datasets that will be process.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @return A list containing the datasets metadata.
#' @examples
#' a
#' @export
#' @md
get_datasets_metadata = function(datasets_DOI,
                                 BASE_URL=Sys.getenv("BASE_URL"),
                                 API_TOKEN=Sys.getenv("API_TOKEN"),
                                 verbose=TRUE) {

    metadata_list = list()
    N = length(datasets_DOI)
    
    if (verbose) {pb = txtProgressBar(min=0, max=N, style=3)}
    for (i in 1:N) {
        if (verbose) setTxtProgressBar(pb, i)
        
        dataset_DOI = datasets_DOI[i]

        api_url = paste0(BASE_URL, "/api/datasets/:persistentId/?persistentId=", dataset_DOI)
        response = httr::GET(api_url, httr::add_headers("X-Dataverse-key"=API_TOKEN))
        
        if (httr::status_code(response) != 200) {
            stop(paste0(httr::status_code(response), " ",
                        httr::content(response, "text")))
        }

        response_content = httr::content(response, as="text",
                                         encoding="UTF-8")
        dataset_info = jsonlite::fromJSON(response_content,
                                          simplifyDataFrame=FALSE,
                                          simplifyVector=TRUE)
        metadata = dataset_info$data[c("metadataLanguage",
                                       "latestVersion")]
        if (N == 1) {
            metadata_list = metadata
        } else {
            metadata_list = append(metadata_list, list(metadata))
            names(metadata_list)[i] = dataset_DOI
        }
    }
    if (verbose) close(pb)
    return (metadata_list)
}


#' @title modify_datasets
#' @description Modify datasets metadata from a selection of metadata json file. See [generate_metadata()] in order to generate efficiently metadata json file.
#' @param dataverse A character string specifying the name of the dataverse in which to create datasets.
#' @param datasets_DOI A vector of character string representing the DOI of datasets that will be process.
#' @param metadata_paths A vector of character string for the paths of json files containing the datasets metadata.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @examples
#' a
#' @export
#' @md
modify_datasets = function(dataverse,
                           datasets_DOI,
                           metadata_paths,
                           BASE_URL=Sys.getenv("BASE_URL"),
                           API_TOKEN=Sys.getenv("API_TOKEN"),
                           verbose=TRUE) {

    N = length(metadata_paths)
    
    if (verbose) {pb = txtProgressBar(min=0, max=N, style=3)}
    for (i in 1:N) {
        if (verbose) setTxtProgressBar(pb, i)

        dataset_DOI = datasets_DOI[i]
        metadata_path = metadata_paths[i]
    
        metadata_json = jsonlite::fromJSON(metadata_path,
                                           simplifyDataFrame=FALSE,
                                           simplifyVector=FALSE)
        modify_url = paste0(BASE_URL,
                            "/api/datasets/:persistentId/versions/:draft?persistentId=",
                            dataset_DOI)

        response = httr::PUT(modify_url,
                             httr::add_headers("X-Dataverse-key"=API_TOKEN),
                             body=metadata_json$datasetVersion,
                             encode="json")

        if (httr::status_code(response) != 200) {
            stop(paste0(httr::status_code(response), " ",
                        httr::content(response, "text")))
        }

        dataset_info = httr::content(response, "parsed")
        dataset_DOI_URL = gsub("doi[:]",
                               "https://doi.org/",
                               dataset_DOI)

        if (verbose) {
            message(paste0("Dataset of DOI ", dataset_DOI,
                           " has been modify in ",
                           BASE_URL, "/dataverse/",
                           dataverse, " at ", dataset_DOI_URL))
        }
    }
    if (verbose) close(pb)
}


#' @title add_dataset_files
#' @description This function uploads files to a dataset.
#' @param dataset_DOI A character string representing the DOI of dataset that will be process
#' @param paths A vector of character string of paths of the files that needs to be uploaded. If you want to conserve a directory structure, set the name of each file path to the directory name wanted.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @return A character vector containing the paths of the files that could not be uploaded, if any.
#' @examples
#' a
#' @export
#' @md
add_dataset_files = function(dataset_DOI, paths,
                             BASE_URL=Sys.getenv("BASE_URL"),
                             API_TOKEN=Sys.getenv("API_TOKEN"),
                             verbose=TRUE) {
    url = paste0(BASE_URL,
                 '/api/datasets/:persistentId/add?persistentId=',
                 dataset_DOI)
    not_added = c()

    N = length(paths)
    
    if (verbose) {pb = txtProgressBar(min=0, max=N, style=3)}
    for (i in 1:N) {
        if (verbose) setTxtProgressBar(pb, i)
        
        path = paths[i]
        directory_label = names(paths)[i]
        
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
                           file = httr::upload_file(path),
                           jsonData=I(jsonlite::toJSON(json_data, auto_unbox=TRUE))
                       ),
                       encode="multipart")
        
        if (httr::status_code(response) != 200) {
            not_added = c(not_added, path)
            names(not_added)[length(not_added)] = i
            warning(paste0("file ", i, " : ", path, "\n",
                           httr::status_code(response), " ",
                           httr::content(response, "text")))
        }
    }
    if (verbose) close(pb)
    return (not_added)
}


#' @title list_datasets_files
#' @description Retrieves files informations of a selection of datasets.
#' @param datasets_DOI A vector of character string representing the DOI of datasets that will be process.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @return A [tibble][dplyr::tibble()] containing files information.
#' @examples
#' a
#' @export
#' @md
list_datasets_files = function(datasets_DOI,
                               BASE_URL=Sys.getenv("BASE_URL"),
                               API_TOKEN=Sys.getenv("API_TOKEN")) {

    files_info = dplyr::tibble()
    
    N = length(datasets_DOI)
    
    if (verbose) {pb = txtProgressBar(min=0, max=N, style=3)}
    for (i in 1:N) {
        if (verbose) setTxtProgressBar(pb, i)
        
        dataset_DOI = datasets_DOI[i]
        
        api_url = paste0(BASE_URL,
                         "/api/datasets/:persistentId/?persistentId=",
                         dataset_DOI)
        response = httr::GET(api_url,
                             httr::add_headers("X-Dataverse-key"=API_TOKEN))

        if (httr::status_code(response) != 200) {
            stop(paste0(httr::status_code(response), " ",
                        httr::content(response, "text")))
        }
        
        response_content = httr::content(response, as="text",
                                         encoding="UTF-8")
        dataset_info = jsonlite::fromJSON(response_content)
        files_info_tmp = dataset_info$data$latestVersion$files
        if ("description" %in% names(files_info_tmp)) {
            files_info_tmp = dplyr::select(files_info_tmp, -description)
        }
        files_info_tmp = tidyr::unnest(files_info_tmp, cols=c(dataFile))
        files_info_tmp = dplyr::rename(files_info_tmp, file_DOI=persistentId)
        files_info_tmp$dataset_DOI = dataset_DOI
        files_info_tmp = dplyr::relocate(files_info_tmp, dataset_DOI,
                                         .before=dplyr::everything())
        
        files_info = dplyr::bind_rows(files_info, files_info_tmp)
    }
    if (verbose) close(pb)
    return (files_info)
}


#' @title download_files
#' @description Download files based on their DOI.
#' @param files_DOI A vector of character string of the DOI of files to be processed.
#' @param save_paths A vector of character string representing the local path where files should be saved.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @examples
#' a
#' @export
#' @md
download_files = function(files_DOI,
                          save_paths,
                          BASE_URL=Sys.getenv("BASE_URL"),
                          API_TOKEN=Sys.getenv("API_TOKEN"),
                          verbose=TRUE) {

    N = length(files_DOI)
    
    if (verbose) {pb = txtProgressBar(min=0, max=N, style=3)}
    for (i in 1:N) {
        if (verbose) setTxtProgressBar(pb, i)
        
        file_DOI = files_DOI[i]
        save_path = save_paths[i]
        
        # Construct API URL
        api_url = paste0(BASE_URL, "/api/access/datafile/:persistentId/?persistentId=", file_DOI)
        
        # Make the request
        response = httr::GET(api_url, 
                             httr::add_headers("X-Dataverse-key"=API_TOKEN),
                             httr::write_disk(save_path, overwrite=TRUE))
        
        # Check response status
        if (httr::status_code(response) != 200) {
            stop(paste0(httr::status_code(response), " ",
                        httr::content(response, "text")))
        }
        if (verbose) {
            message(paste0("File ", file_DOI, " saved to : ", save_path))
        }
    }
    if (verbose) close(pb)
}


#' @title delete_datasets_files
#' @description Delete files based on their DOI.
#' @param files_DOI A vector of character string of the DOI of files to be processed.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @examples
#' .
#' @export
#' @md
delete_datasets_files = function(files_DOI,
                                 BASE_URL=Sys.getenv("BASE_URL"),
                                 API_TOKEN=Sys.getenv("API_TOKEN"),
                                 verbose=TRUE) {

    N = length(files_DOI)
    
    if (verbose) {pb = txtProgressBar(min=0, max=N, style=3)}
    for (i in 1:N) {
        if (verbose) setTxtProgressBar(pb, i)
        
        file_DOI = files_DOI[i]
        
        delete_url =
            paste0(BASE_URL, "/api/files/:persistentId/?persistentId=", file_DOI)

        response = httr::DELETE(delete_url,
                                httr::add_headers("X-Dataverse-key"=API_TOKEN))
        
        if (httr::status_code(response) != 200) {
            stop(paste0(httr::status_code(response), " ",
                        httr::content(response, "text")))
        }
        if (verbose) {
            message(paste0("File", file_DOI, " deleted"))
        }
    }
    if (verbose) close(pb)
}


#' @title delete_all_datasets_files
#' @description Delete all files from a selection of datasets.
#' @param datasets_DOI A vector of character string representing the DOI of datasets that will be process.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @examples
#' a
#' @export
#' @md
delete_all_datasets_files = function(datasets_DOI,
                                     BASE_URL=Sys.getenv("BASE_URL"),
                                     API_TOKEN=Sys.getenv("API_TOKEN"),
                                     verbose=TRUE) {

    N = length(datasets_DOI)
    
    if (verbose) {pb = txtProgressBar(min=0, max=N, style=3)}
    for (i in 1:N) {
        if (verbose) setTxtProgressBar(pb, i)
        
        dataset_DOI = datasets_DOI[i]
        
        files_info = list_dataset_files(dataset_DOI=dataset_DOI,
                                        BASE_URL=BASE_URL,
                                        API_TOKEN=API_TOKEN)
        nFiles = nrow(files_info)
        
        for (j in 1:nFiles) {
            file_info = files_info[j, ]
            delete_dataset_file(file_DOI=file_info$file_DOI,
                                BASE_URL=BASE_URL,
                                API_TOKEN=API_TOKEN,
                                verbose=FALSE)
            
            # delete_url = paste0(BASE_URL, "/api/files/", file_id)
            # response = httr::DELETE(delete_url,
            # httr::add_headers("X-Dataverse-key"=API_TOKEN))
            
            # if (httr::status_code(response) == 200) {
            # print(paste0(i, ": ", file_info$id, " -> ok"))
            # } else {
            # print(paste0(i, ": ", file_info$id, " -> error ",
            # httr::status_code(response), " ",
            # httr::content(response, "text")))
            # }
        }
        if (verbose) {
            message(paste0("All files deleted in dataset ", dataset_DOI))
        }
    }
    if (verbose) close(pb)
}


#' @title publish_datasets
#' @description Publish a selection of datasets.
#' @param datasets_DOI A vector of character string representing the DOI of datasets that will be process.
#' @param type A character string specifying the type of publication. Use `"major"` if at least a file as been modified of supressed, if only metadata have changed, use `"minor"`.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @examples
#' a
#' @export
#' @md
publish_datasets = function(datasets_DOI, type="major",
                            BASE_URL=Sys.getenv("BASE_URL"),
                            API_TOKEN=Sys.getenv("API_TOKEN"),
                            verbose=TRUE) {

    N = length(datasets_DOI)

    if (verbose) {pb = txtProgressBar(min=0, max=N, style=3)}
    for (i in 1:N) {
        if (verbose) setTxtProgressBar(pb, i)
        
        dataset_DOI = datasets_DOI[i]
        
        publish_url = paste0(BASE_URL, "/api/datasets/:persistentId/actions/:publish?persistentId=",
                             dataset_DOI, "&type=", type)
        response = httr::POST(publish_url,
                              httr::add_headers("X-Dataverse-key"=API_TOKEN))
        
        if (httr::status_code(response) != 200) {
            stop(paste0(httr::status_code(response), " ",
                        httr::content(response, "text")))
        }

        if (verbose) {
            message(paste0("Dataset ", dataset_DOI, " published"))
        }
    }
    if (verbose) close(pb)
}


#' @title delete_datasets
#' @description Delete a selection of unpublished datasets.
#' @param datasets_DOI A vector of character string representing the DOI of datasets that will be process.
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @param verbose If FALSE, no processing informations are displayed. By default, TRUE.
#' @examples
#' a
#' @export
#' @md
delete_datasets = function(datasets_DOI,
                           BASE_URL=Sys.getenv("BASE_URL"),
                           API_TOKEN=Sys.getenv("API_TOKEN"),
                           verbose=TRUE) {
    
    N = length(datasets_DOI)

    if (verbose) {pb = txtProgressBar(min=0, max=N, style=3)}
    for (i in 1:N) {
        if (verbose) setTxtProgressBar(pb, i)
        
        dataset_DOI = datasets_DOI[i]

        delete_url = paste0(BASE_URL, "/api/datasets/:persistentId/?persistentId=", dataset_DOI)
        response = httr::DELETE(delete_url,
                                httr::add_headers("X-Dataverse-key"=API_TOKEN))
        
        if (httr::status_code(response) != 200) {
            warning(paste0(httr::status_code(response), " ",
                           httr::content(response, "text")))
        }
        if (verbose) {
            message(paste0("Dataset ", dataset_DOI, " deleted"))
        }
    }
    if (verbose) close(pb)
}
