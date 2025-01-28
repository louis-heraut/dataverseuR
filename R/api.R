

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





publish_dataset = function(BASE_URL=Sys.getenv("BASE_URL"),
                           API_TOKEN=Sys.getenv("API_TOKEN"),
                           dataset_DOI, type="major") {
    
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



# status “RELEASED” or “DRAFT”
search = function(BASE_URL=Sys.getenv("BASE_URL"),
                  API_TOKEN=Sys.getenv("API_TOKEN"),
                  query="*", publication_status="*",
                  type="*", dataverse="",
                  n_search="10") {

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


# dataverse = search(BASE_URL, API_TOKEN, query="Explore2", type="dataverse")


get_doi_from_datasets = function (datasets) {
    name = sapply(datasets$items, function (x) x$name)
    DOI = sapply(datasets$items, function (x) x$global_id)
    names(DOI) = name
    return (DOI)
}







get_dataset_metadata = function(BASE_URL=Sys.getenv("BASE_URL"),
                                API_TOKEN=Sys.getenv("API_TOKEN"),
                                dataset_DOI) {
    
    # Construct the API URL using the provided DOI
    api_url = paste0(BASE_URL, "/api/datasets/:persistentId/?persistentId=", dataset_DOI)
    
    # Send httr::GET request to the API
    response = httr::GET(api_url, httr::add_headers("X-Dataverse-key" = API_TOKEN))
    
    # Check if the request was successful
    if (httr::status_code(response) == 200) {
        # Parse the content of the response
        response_content = httr::content(response, as = "text", encoding = "UTF-8")
        dataset_info = jsonlite::fromJSON(response_content)
        # Return the dataset metadata
        return(dataset_info$data)
    } else {
        # Handle errors
        cat("Failed to retrieve dataset metadata.\n")
        cat("Status code: ", httr::status_code(response), "\n")
        cat("Response content: ", httr::content(response, as = "text", encoding = "UTF-8"), "\n")
        stop("Error during metadata retrieval.")
    }
}




create_dataset = function(BASE_URL=Sys.getenv("BASE_URL"),
                          API_TOKEN=Sys.getenv("API_TOKEN"),
                          dataverse = "root",
                          metadata_path) {

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
        cat("Response content: ", httr::content(response, as = "text", encoding = "UTF-8"), "\n")
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


get_dataset_metadata = function(BASE_URL=Sys.getenv("BASE_URL"),
                                API_TOKEN=Sys.getenv("API_TOKEN"),
                                dataset_DOI) {

    get_url = paste0(BASE_URL, "/api/datasets/:persistentId/versions/:latest?persistentId=", dataset_DOI)
    
    response = httr::GET(get_url, httr::add_headers("X-Dataverse-key" = API_TOKEN))
    
    if (httr::status_code(response) == 200) {
        cat("Metadata retrieved successfully.\n")
        metadata = httr::content(response, "parsed")
        return(metadata$data) # Return only the data object
    } else {
        cat("Failed to retrieve metadata.\n")
        cat("Status code: ", httr::status_code(response), "\n")
        cat("Response content: ", httr::content(response, as = "text", encoding = "UTF-8"), "\n")
        stop("Error during metadata retrieval.")
    }
}




modify_dataset_metadata = function(BASE_URL=Sys.getenv("BASE_URL"),
                                   API_TOKEN=Sys.getenv("API_TOKEN"),
                                   dataset_DOI,
                                   metadata_path) {

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

    updated_metadata = httr::content(response, "parsed")
    dataset_DOI_URL = gsub("doi[:]",
                           "https://doi.org/",
                           dataset_DOI)
    message(paste0("Dataset of DOI ", dataset_DOI,
                   " has been modify in ",
                   BASE_URL, "/dataverse/",
                   dataverse, " at ", dataset_DOI_URL))
    
    return (dataset_DOI)
}




add_dataset_files = function(BASE_URL=Sys.getenv("BASE_URL"),
                             API_TOKEN=Sys.getenv("API_TOKEN"),
                             dataset_DOI, paths) {
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



list_dataset_files = function(BASE_URL=Sys.getenv("BASE_URL"),
                              API_TOKEN=Sys.getenv("API_TOKEN"),
                              dataset_DOI) {
    
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


delete_dataset_files = function(BASE_URL=Sys.getenv("BASE_URL"),
                                API_TOKEN=Sys.getenv("API_TOKEN"),
                                dataset_DOI) {
    
    files = list_dataset_files(BASE_URL, API_TOKEN, dataset_DOI)
    
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
