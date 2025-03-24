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


#' @title get_dotenv
#' @description This function copies a predefined `.env` file from the package's extdata directory to a specified path. It also prints a message advising the user to fill in their credentials and rename the file to `.env`. The copied file serves as a template for environment variables required for authentication or other configuration.
#' @param dotenv_path A character string representing the destination path where the `.env` file should be copied. By default, it copies to the `dist.env` file in the working directory.
#' @return The function returns the path to the copied `.env` file.
#' @examples
#' # Copy the .env file to a specific location
#' get_dotenv("path/to/your/.env")
#' 
#' # Copy the .env file to the default location (current working directory)
#' get_dotenv()
#' @export
#' @md
get_dotenv = function(dotenv_path=file.path(getwd(), "dist.env")) {
    dotenv_from_path = system.file("extdata", "dist.env",
                                   package="dataverseur")
    file.copy(dotenv_from_path, dotenv_path, overwrite=TRUE)
    message(paste0("The '", basename(dotenv_path),
                   "' file has been copied to : '",
                   dotenv_path,
                   "'\n\nPLease fill in your credential and rename that file '.env'.\n/!\\ NEVER give your personnal credential through a GIT repo."))
    return (dotenv_path)
}


search_metadata_blocks = function() {
    search_url = "https://entrepot.recherche.data.gouv.fr/api/metadatablocks/citation"
    # search_url = modify_url(base_url, query=query_params)
    response = httr::GET(search_url)
    
    if (httr::status_code(response) == 200) {
        metadata_blocks = httr::content(response, "parsed")
        return(metadata_blocks)
    } else {
        cat("Failed to retrieve metadata blocks.\n")
        cat("Status code: ", httr::status_code(response), "\n")
        cat("Response content: ", httr::content(response, as = "text", encoding = "UTF-8"), "\n")
        stop("Error during API request.")
    }
}


# status “RELEASED” or “DRAFT”
#' @title search
#' @description This function performs a search query on the Dataverse API. It allows users to search for datasets based on a query, publication status, type, and associated dataverse. The function returns datasets matching the search parameters, fetched via an API call to the Dataverse platform.
#' @param query A character string specifying the search query. The default value is "*" which means a search for all datasets.
#' @param publication_status A character string specifying the publication status of the datasets. Valid options are "DRAFT", "RELEASED", or a specific status. The default is "*", meaning all statuses.
#' @param type A character string specifying the type of the dataset. The default is "*", meaning all types.
#' @param dataverse A character string specifying the dataverse to search within. If left empty, the search will query all available dataverses.
#' @param n_search A character string indicating the number of results to return. Default is "10".
#' @param BASE_URL A character string for the base URL of the Dataverse API. By default, it uses the value from the environment variable `BASE_URL`.
#' @param API_TOKEN A character string for the API token required to authenticate the request. By default, it uses the value from the environment variable `API_TOKEN`.
#' @details
#' ChatGPT help (need to be tested) :
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
#' @return A list of datasets returned from the Dataverse search query. If the API request fails, an error message is printed, and the function stops.
#' @examples
#' # Perform a search for datasets with the default parameters
#' search()
#' 
#' # Perform a search for datasets in a specific dataverse with publication status 'RELEASED'
#' search(query="climate change", publication_status="RELEASED", dataverse="earth-sciences")
#' 
#' # Perform a search with custom results per page
#' search(n_search="20")
#' @export
#' @md
search = function(query="*", publication_status="*",
                  type="*", dataverse="",
                  n_search="10",
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
    
    if (httr::status_code(response) == 200) {
        datasets = httr::content(response, "parsed")$data
        return(datasets)
        
    } else {
        cat("Failed to retrieve datasets from sub-dataverse.\n")
        cat("Status code: ", httr::status_code(response), "\n")
        cat("Response content: ", httr::content(response, as = "text", encoding = "UTF-8"), "\n")
        stop("Error during API request.")
    }
}


#' @title get_DOI_from_datasets_search
#' @description This function extracts the DOIs (Digital Object Identifiers) from a dataset object. It takes a list of datasets and returns a named vector where the names correspond to the dataset names and the values correspond to their respective DOIs.
#' @param datasets_search A dataset object, typically a list or data frame, containing items with `name` and `global_id` attributes, where `global_id` represents the DOI.
#' @return A named vector where each name is the dataset name and each value is the corresponding DOI.
#' @examples
#' # Example dataset with items containing names and global_ids
#' datasets <- list(items = list(list(name = "Dataset 1", global_id = "10.1234/abc"), 
#'                               list(name = "Dataset 2", global_id = "10.5678/def")))
#' get_DOI_from_datasets_search(datasets)
#' @export
#' @md
get_DOI_from_datasets_search = function (datasets_search) {
    name = sapply(datasets_search$items, function (x) x$name)
    DOI = sapply(datasets_search$items, function (x) x$global_id)
    names(DOI) = name
    return (DOI)
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

#' @title convert_datasets_search_to_tibble
#' @export
#' @md
convert_datasets_search_to_tibble = function (datasets_search) {
    results = dplyr::tibble()
    for (dataset in datasets_search$items) {
        results_tmp = convert_datasets_to_tibble_hide(dataset)
        results = dplyr::bind_rows(results, results_tmp)
    }
    results = dplyr::rename(results, dataset_DOI=global_id)
    return (results)
}

#' @title get_datasets_size
#' @description This function retrieves the total storage size (in bytes) of a dataset from the Dataverse API.
#' @param datasets_DOI A character string or vector representing the dataset DOIs.
#' @param BASE_URL A character string representing the base URL for the Dataverse installation (default is the environment variable `BASE_URL`).
#' @param API_TOKEN A character string representing the API token for authentication (default is the environment variable `API_TOKEN`).
#' @return A tibble containing dataset DOIs and their corresponding total storage sizes in bytes.
#' @examples
#' # Retrieve dataset storage size
#' get_datasets_size("24")
#' @export
#' @md
get_datasets_size = function(datasets_DOI,
                             BASE_URL=Sys.getenv("BASE_URL"),
                             API_TOKEN=Sys.getenv("API_TOKEN")) {

    results = dplyr::tibble()
    
    for (dataset_DOI in datasets_DOI) {        
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
            size_value = NA
        }
        
        results_tmp = dplyr::tibble(dataset_DOI=dataset_DOI,
                                    storage_size_bytes=size_value)
        results = dplyr::bind_rows(results, results_tmp)
    }
    results$storage_size_GB = round(results$storage_size_bytes/1024**3, 3)
    
    return(results)
}



#' @title get_datasets_metrics
#' @description This function retrieves dataset metrics (views, downloads, and citations) from the Dataverse API for a given dataset DOI.
#' @param datasets_DOI A character string or vector representing the DOI of the datasets.
#' @param BASE_URL A character string representing the base URL for the Dataverse installation (default is the environment variable `BASE_URL`).
#' @param API_TOKEN A character string representing the API token for authentication (default is the environment variable `API_TOKEN`).
#' @return A named list containing total views, unique views, total downloads, unique downloads, and citations.
#' @examples
#' # Retrieve dataset metrics
#' get_dataset_metrics("doi:10.5072/FK2/J8SJZB")
#' @export
#' @md
get_datasets_metrics = function(datasets_DOI,
                               BASE_URL=Sys.getenv("BASE_URL"),
                               API_TOKEN=Sys.getenv("API_TOKEN")) {

    results = dplyr::tibble()
    metrics = c("viewsTotal", "viewsUnique",
                "downloadsTotal", "downloadsUnique") #"citations"
    
    for (dataset_DOI in datasets_DOI) {
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
                metric_value = NA
            }
            results_tmp = c(results_tmp, metric_value)
        }
        # results_tmp = as.numeric(results_tmp)
        results_tmp = c(dataset_DOI=dataset_DOI, results_tmp)
        results_tmp = dplyr::tibble(!!!results_tmp)
        results = dplyr::bind_rows(results, results_tmp)
    }
    results = dplyr::mutate(results,
                            dplyr::across(.cols=metrics,
                                          .fns=as.numeric))
    return (results)
}



#' @title create_dataset
#' @description This function creates a new dataset in a specified Dataverse. It takes metadata from a JSON file, sends a request to the Dataverse API to create the dataset, and returns the persistent DOI of the newly created dataset. If the request fails, the function provides an error message with status code and response content.
#' @param dataverse A character string specifying the name of the Dataverse in which to create the dataset.
#' @param metadata_path A character string representing the path to a JSON file containing the dataset metadata.
#' @param BASE_URL A character string representing the base URL for the Dataverse installation (default is the environment variable `BASE_URL`).
#' @param API_TOKEN A character string representing the API token for authenticating with the Dataverse API (default is the environment variable `API_TOKEN`).
#' @return The function returns the DOI of the newly created dataset as a character string.
#' @examples
#' # Create a new dataset using a metadata file
#' create_dataset("my_dataverse", "path/to/metadata.json")
#' 
#' # Create a new dataset with custom API token and base URL
#' create_dataset("my_dataverse", "path/to/metadata.json", BASE_URL="https://mydataverse.example.com", API_TOKEN="your_api_token")
#' @export
#' @md
create_dataset = function(dataverse,
                          metadata_path,
                          BASE_URL=Sys.getenv("BASE_URL"),
                          API_TOKEN=Sys.getenv("API_TOKEN")) {

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
        cat("Failed to create dataset.\n")
        cat("Status code: ", httr::status_code(response), "\n")
        cat("Response content: ",
            httr::content(response, as="text",
                          encoding="UTF-8"), "\n")
        stop("Error during dataset creation.")
    }

    dataset_info = httr::content(response, "parsed")
    dataset_DOI = dataset_info$data$persistentId
    dataset_DOI_URL = gsub("doi[:]",
                           "https://doi.org/",
                           dataset_DOI)
    message(paste0("Dataset of DOI ", dataset_DOI,
                   " has been created in ",
                   BASE_URL, "/dataverse/",
                   dataverse, " at ", dataset_DOI_URL))
    return (dataset_DOI)
}


#' @title get_dataset_metadata
#' @description This function retrieves metadata for a dataset using its DOI (Digital Object Identifier) from a Dataverse repository. It makes an API call to the Dataverse server using the provided or default credentials (BASE_URL and API_TOKEN), and returns the dataset's metadata if the request is successful. If the request fails, it prints an error message with the status code and response content.
#' @param dataset_DOI A character string representing the DOI of the dataset whose metadata is to be retrieved.
#' @param BASE_URL A character string representing the base URL of the Dataverse repository. The default is the value of the environment variable `BASE_URL`.
#' @param API_TOKEN A character string representing the API token for authentication. The default is the value of the environment variable `API_TOKEN`.
#' @return A list containing the dataset metadata if the request is successful. If the request fails, the function stops and returns an error message.
#' @examples
#' # Retrieve metadata for a dataset using its DOI
#' dataset_info = get_dataset_metadata("doi:10.1234/abcde12345")
#' 
#' # Using custom BASE_URL and API_TOKEN
#' dataset_info = get_dataset_metadata("doi:10.1234/abcde12345", BASE_URL="https://dataverse.example.com", API_TOKEN="your_api_token")
#' @export
#' @md
get_dataset_metadata = function(dataset_DOI,
                                BASE_URL=Sys.getenv("BASE_URL"),
                                API_TOKEN=Sys.getenv("API_TOKEN")) {
    
    api_url = paste0(BASE_URL, "/api/datasets/:persistentId/?persistentId=", dataset_DOI)
    
    response = httr::GET(api_url, httr::add_headers("X-Dataverse-key" = API_TOKEN))
    
    if (httr::status_code(response) != 200) {
        cat("Failed to retrieve dataset metadata.\n")
        cat("Status code: ", httr::status_code(response), "\n")
        cat("Response content: ", httr::content(response, as = "text", encoding = "UTF-8"), "\n")
        stop("Error during metadata retrieval.")
    }

    response_content = httr::content(response, as="text",
                                     encoding="UTF-8")
    dataset_info = jsonlite::fromJSON(response_content,
                                      simplifyDataFrame=FALSE,
                                      simplifyVector=TRUE)

    metadata = dataset_info$data[c("metadataLanguage",
                                   "latestVersion")]
    return (metadata)
}


#' @title modify_dataset_metadata
#' @description This function modifies the metadata of a dataset in a Dataverse repository. It accepts the dataset DOI, the path to a metadata JSON file, and uses the Dataverse API to update the dataset's metadata. The function checks the response for success and outputs relevant information. It is designed to facilitate metadata management and updating in Dataverse.
#' @param dataverse A character string representing the name of the Dataverse repository.
#' @param dataset_DOI A character string representing the DOI of the dataset to modify.
#' @param metadata_path A character string indicating the file path to the metadata JSON file that will be used for the update.
#' @param BASE_URL A character string representing the base URL of the Dataverse installation. Defaults to the environment variable `BASE_URL`.
#' @param API_TOKEN A character string representing the API token for authentication. Defaults to the environment variable `API_TOKEN`.
#' @return The function returns the DOI of the modified dataset.
#' @examples
#' # Modify the metadata of a dataset
#' modify_dataset_metadata(dataverse = "myDataverse", 
#'                          dataset_DOI = "doi:10.1234/abcd", 
#'                          metadata_path = "metadata.json")
#' 
#' # Modify the metadata with a custom BASE_URL and API_TOKEN
#' modify_dataset_metadata(dataverse = "myDataverse", 
#'                          dataset_DOI = "doi:10.1234/abcd", 
#'                          metadata_path = "metadata.json",
#'                          BASE_URL = "https://mydataverse.org", 
#'                          API_TOKEN = "myapitoken123")
#' @export
#' @md
modify_dataset_metadata = function(dataverse,
                                   dataset_DOI,
                                   metadata_path,
                                   BASE_URL=Sys.getenv("BASE_URL"),
                                   API_TOKEN=Sys.getenv("API_TOKEN")) {

    metadata_json = jsonlite::fromJSON(metadata_path,
                                       simplifyDataFrame = FALSE,
                                       simplifyVector = FALSE)
    modify_url = paste0(BASE_URL,
                        "/api/datasets/:persistentId/versions/:draft?persistentId=",
                        dataset_DOI)

    response = httr::PUT(modify_url,
                         httr::add_headers("X-Dataverse-key" = API_TOKEN),
                         body = metadata_json$datasetVersion,
                         encode = "json")

    if (httr::status_code(response) != 200) {
        cat("Failed to add/update metadata.\n")
        cat("Status code: ", httr::status_code(response), "\n")
        cat("Response content: ", httr::content(response, as = "text", encoding = "UTF-8"), "\n")
        stop("Error during metadata addition.")
    }

    dataset_info = httr::content(response, "parsed")
    dataset_DOI_URL = gsub("doi[:]",
                           "https://doi.org/",
                           dataset_DOI)
    message(paste0("Dataset of DOI ", dataset_DOI,
                   " has been modify in ",
                   BASE_URL, "/dataverse/",
                   dataverse, " at ", dataset_DOI_URL))
    
    return (dataset_DOI)
}


#' @title add_dataset_files
#' @description This function uploads files to a specified Dataverse dataset using its DOI. The function sends HTTP POST requests to the Dataverse API to add files, and reports the status of each upload. If a file cannot be uploaded, it is added to the `not_added` list, which is returned at the end.
#' @param dataset_DOI A character string representing the DOI of the dataset to which files will be added.
#' @param paths A named list where the names correspond to the directory labels and the values are paths to the files to be uploaded.
#' @param BASE_URL A character string specifying the base URL of the Dataverse instance. Defaults to the value of the `BASE_URL` environment variable.
#' @param API_TOKEN A character string representing the API token for authenticating with the Dataverse API. Defaults to the value of the `API_TOKEN` environment variable.
#' @return A character vector containing the paths of the files that could not be uploaded, if any.
#' @examples
#' # Add files to a dataset with a specific DOI
#' not_uploaded = add_dataset_files("doi:10.1234/abcde", c("file1.txt", "file2.csv"))
#' 
#' # Add files to a dataset with directory labels
#' paths = list("directory1" = "file1.txt", "directory2" = "file2.csv")
#' not_uploaded = add_dataset_files("doi:10.1234/abcde", paths)
#' @export
#' @md
add_dataset_files = function(dataset_DOI, paths,
                             BASE_URL=Sys.getenv("BASE_URL"),
                             API_TOKEN=Sys.getenv("API_TOKEN")) {
    url = paste0(BASE_URL,
                 '/api/datasets/:persistentId/add?persistentId=',
                 dataset_DOI)
    not_added = c()
    
    for (i in 1:length(paths)) {
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
                       encode = "multipart")
        
        if (httr::status_code(response) == 200) {
            print(paste0(i, ": ", path, " -> ok"))
        } else {
            not_added = c(not_added, path)
            names(not_added)[length(not_added)] = i 
            print(paste0(i, ": ", path, " -> error ",
                         httr::status_code(response), " ",
                         httr::content(response, "text")))
        }
    }
    
    return (not_added)
}


#' @title list_dataset_files
#' @description This function retrieves the list of files associated with a dataset from a Dataverse repository, given the dataset's DOI. It makes an API request to the Dataverse server and processes the response to extract file information, such as file names and metadata. The function uses the base URL and API token provided by the user or defaults to system environment variables.
#' @param dataset_DOI A character string representing the DOI (Digital Object Identifier) of the dataset for which the files are to be listed.
#' @param BASE_URL A character string representing the base URL of the Dataverse API (default is taken from the system environment variable `BASE_URL`).
#' @param API_TOKEN A character string representing the API token used for authentication with the Dataverse API (default is taken from the system environment variable `API_TOKEN`).
#' @return A data frame containing information about the files associated with the dataset, excluding the description field.
#' @examples
#' # List files for a dataset with a specific DOI
#' files <- list_dataset_files("doi:10.1234/abc123")
#' 
#' # Use custom URL and token to list dataset files
#' files <- list_dataset_files("doi:10.1234/abc123", BASE_URL = "https://dataverse.example.com", API_TOKEN = "your_api_token")
#' @export
#' @md
list_dataset_files = function(dataset_DOI,
                              BASE_URL=Sys.getenv("BASE_URL"),
                              API_TOKEN=Sys.getenv("API_TOKEN")) {
    
    api_url = paste0(BASE_URL,
                     "/api/datasets/:persistentId/?persistentId=",
                     dataset_DOI)
    response = httr::GET(api_url,
                         httr::add_headers("X-Dataverse-key"=API_TOKEN))

    if (httr::status_code(response) != 200) {
        cat("Failed to retrieve dataset information.\n")
        cat("Status code: ", httr::status_code(response), "\n")
        cat("Response content: ", httr::content(response, as = "text", encoding = "UTF-8"), "\n")
        stop("Error during API request.")
    }
    
    response_content = httr::content(response, as="text",
                                     encoding="UTF-8")
    dataset_info = jsonlite::fromJSON(response_content)
    files = dataset_info$data$latestVersion$files
    files = dplyr::select(files, -description)
    files = tidyr::unnest(files, cols=c(dataFile))
    
    return(files)
}


#' @title delete_dataset_files
#' @description This function deletes all files associated with a dataset in the Dataverse repository. It first retrieves the list of files from the specified dataset and then iterates through each file, sending a DELETE request to remove each one. The function reports success or failure for each file.
#' @param dataset_DOI A character string representing the DOI (Digital Object Identifier) of the dataset from which the files will be deleted.
#' @param BASE_URL A character string representing the base URL of the Dataverse installation. Default is fetched from the `BASE_URL` environment variable.
#' @param API_TOKEN A character string representing the API token used for authentication. Default is fetched from the `API_TOKEN` environment variable.
#' @return The function does not return any value. It prints messages indicating the status of each file deletion.
#' @examples
#' # Delete files from a dataset with a specific DOI
#' delete_dataset_files("doi:10.1234/abcd")
#' 
#' # Delete files from a dataset using custom URL and API token
#' delete_dataset_files("doi:10.1234/abcd", BASE_URL = "https://dataverse.example.com", API_TOKEN = "your_api_token")
#' @export
#' @md
delete_dataset_files = function(dataset_DOI,
                                BASE_URL=Sys.getenv("BASE_URL"),
                                API_TOKEN=Sys.getenv("API_TOKEN")) {
    
    files = list_dataset_files(dataset_DOI, BASE_URL, API_TOKEN)
    
    for (i in 1:nrow(files)) {
        file_info = files[i, ]
        file_id = file_info$id
        delete_url = paste0(BASE_URL, "/api/files/", file_id)
        response = httr::DELETE(delete_url,
                                httr::add_headers("X-Dataverse-key"=API_TOKEN))
        
        if (httr::status_code(response) == 200) {
            print(paste0(i, ": ", file_info$id, " -> ok"))
        } else {
            print(paste0(i, ": ", file_info$id, " -> error ",
                         httr::status_code(response), " ",
                         httr::content(response, "text")))
        }
    }
}


#' @title publish_dataset
#' @description This function publishes a dataset in Dataverse using its DOI. The function sends a POST request to the Dataverse API, passing the DOI of the dataset and a specified type (e.g., major or minor) of publication. Upon success, it prints a success message, otherwise, it reports an error.
#' @param dataset_DOI A character string representing the DOI (Digital Object Identifier) of the dataset to be published.
#' @param type A character string specifying the type of publication. Options are "major" or "minor". Default is "major".
#' @param BASE_URL A character string representing the base URL of the Dataverse installation. Default is fetched from the `BASE_URL` environment variable.
#' @param API_TOKEN A character string representing the API token used for authentication. Default is fetched from the `API_TOKEN` environment variable.
#' @return The function does not return any value. It prints messages indicating whether the dataset was successfully published or if an error occurred.
#' @examples
#' # Publish a dataset with a specific DOI
#' publish_dataset("doi:10.1234/abcd")
#' 
#' # Publish a dataset with custom parameters
#' publish_dataset("doi:10.1234/abcd", type = "minor", BASE_URL = "https://dataverse.example.com", API_TOKEN = "your_api_token")
#' @export
#' @md
publish_dataset = function(dataset_DOI, type="major",
                           BASE_URL=Sys.getenv("BASE_URL"),
                           API_TOKEN=Sys.getenv("API_TOKEN")) {
    
    publish_url = paste0(BASE_URL, "/api/datasets/:persistentId/actions/:publish?persistentId=",
                         dataset_DOI, "&type=", type)
    response = httr::POST(publish_url,
                          httr::add_headers("X-Dataverse-key"=API_TOKEN))
    
    if (httr::status_code(response) == 200) {
        cat("Dataset published successfully.\n")
    } else {
        cat("Failed to publish dataset.\n")
        cat("Status code: ", httr::status_code(response), "\n")
        cat("Response content: ", httr::content(response, as = "text", encoding = "UTF-8"), "\n")
        stop("Error during dataset publication.")
    }
}


#' @title delete_dataset
#' @description This function deletes a dataset in Dataverse using its DOI. It sends a DELETE request to the Dataverse API, passing the DOI of the dataset. Upon success, it prints a success message; otherwise, it reports an error.
#' @param dataset_DOI A character string representing the DOI (Digital Object Identifier) of the dataset to be deleted.
#' @param BASE_URL A character string representing the base URL of the Dataverse installation. Default is fetched from the `BASE_URL` environment variable.
#' @param API_TOKEN A character string representing the API token used for authentication. Default is fetched from the `API_TOKEN` environment variable.
#' @return The function does not return any value. It prints messages indicating whether the dataset was successfully deleted or if an error occurred.
#' @examples
#' # Delete a dataset with a specific DOI
#' delete_dataset("doi:10.1234/abcd")
#' 
#' # Delete a dataset with custom parameters
#' delete_dataset("doi:10.1234/abcd", BASE_URL = "https://dataverse.example.com", API_TOKEN = "your_api_token")
#' @export
#' @md
delete_dataset = function(dataset_DOI,
                          BASE_URL=Sys.getenv("BASE_URL"),
                          API_TOKEN=Sys.getenv("API_TOKEN")) {
    
    delete_url = paste0(BASE_URL, "/api/datasets/:persistentId/?persistentId=", dataset_DOI)
    response = httr::DELETE(delete_url,
                            httr::add_headers("X-Dataverse-key"=API_TOKEN))
    
    if (httr::status_code(response) == 200) {
        cat("Dataset deleted successfully.\n")
    } else {
        cat("Failed to delete dataset.\n")
        cat("Status code: ", httr::status_code(response), "\n")
        cat("Response content: ", httr::content(response, as = "text", encoding = "UTF-8"), "\n")
        stop("Error during dataset deletion.")
    }
}
