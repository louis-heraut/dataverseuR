
#' @title initialise_metadata
#' @description Create an empty R variable metadata environment in which all assigned R variables will represent a dataverse metadata for a unique dataset. See [generate_metadata()] to create the associated json metadata file.
#' @param environment_name A character string representing the name of the R variable metadata environment to be created. The default value is `"META"`.
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' @md
initialise_metadata_old = function (environment_name="META") {
    assign(environment_name, new.env(), envir=as.environment(1))
}


#' @title generate_metadata
#' @description Write a metadata json file and return the associated metadata list based on the R variables contained in the previously initialised R variable metadata environment. See [initialise_metadata()] to create a new R variable environment.
#' @param metadata_dir A character string specifying the directory where the generated metadata json file will be saved. Defaults to the current directory (".").
#' @param metadata_filename A character string specifying filename for the generated metadata. If their is a `filename` variable in the R metadata environment, the default filename is taken from this variable. Default to `"metadata"`.
#' @param environment_name The name of the R variable metadata environment variable containing the metadata values. Defaults to "META".
#' @param overwrite_metadata A logical value indicating whether to overwrite an existing metadata file. Defaults to TRUE.
#' @param dev A logical value indicating whether to use the development template for metadata. Default to FALSE.
#' @param verbose A logical value for whether to print additional information. Default to FALSE.
#' @return A list containing two elements :
#' - `metadata_path` the path to the generated metadata file and
#' - `json` the json list equivalent content of the metadata
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' @md
generate_metadata_old = function (metadata_dir=".",
                                  metadata_filename="metadata",
                                  environment_name="META",
                                  overwrite_metadata=TRUE,
                                  dev=FALSE,
                                  verbose=FALSE) {

    if (dev) {
        full_template_path =
            file.path("inst", "extdata",
                      "RDG_full_metadata_template.json")
    } else {
        full_template_path =
            system.file("extdata",
                        "RDG_full_metadata_template.json",
                        package="dataverseuR")
    }
    
    metadata = jsonlite::fromJSON(full_template_path,
                                  simplifyVector=FALSE,
                                  simplifyDataFrame=FALSE)
    META = get(environment_name, envir=.GlobalEnv)

    if (!is.null(META$filename)) {
        metadata_filename = paste0(META$filename, ".json")
        rm (filename, envir=META)
    } else {
        metadata_filename = paste0(metadata_filename, ".json")
    }
    metadata_path = file.path(metadata_dir, metadata_filename)
    
    TypeNames = ls(envir=META)
    TypeNames_Num = TypeNames[grepl("[[:digit:]]+$", TypeNames)]
    TypeNames_Num_noNum = unique(gsub("[[:digit:]]+$", "",
                                      TypeNames_Num))
    
    get_Num = function (x, All) {
        pattern = paste0("^", x, "[[:digit:]]+$")
        max(as.numeric(stringr::str_extract(All[grepl(pattern, All)],
                                            "[[:digit:]]+$")))
    }

    TypeNames_Num_noNum_n = sapply(TypeNames_Num_noNum,
                                   get_Num,
                                   All=TypeNames_Num)

    for (i in 1:length(TypeNames_Num_noNum_n)) {
        n = TypeNames_Num_noNum_n[i]
        typeName = names(TypeNames_Num_noNum_n)[i]
        if (!(paste0(typeName, n) %in% unlist(metadata))) {
            metadata = replicate_typeName(metadata, typeName, n)
        }
    }

    for (typeName in TypeNames) {
        value = get(typeName, envir=META)
        metadata = add_typeName(metadata, typeName, value)
    }
    metadata = clean_metadata(metadata)

    rm (list=ls(envir=META), envir=META)

    json = jsonlite::toJSON(metadata,
                            pretty=TRUE,
                            auto_unbox=TRUE)
    res = list(metadata_path=metadata_path, json=json)
    
    if (file.exists(metadata_path) & !overwrite_metadata) {
        message (paste0("Metadata file already exists in ",
                        metadata_path))
        return (res)
    }
    
    write(json, metadata_path)
    return (res)
}


#' @title convert_metadata
#' @param metadata metadata
#' @param metadata_yml_path A character string for the name of the metadata R file to write. By default, "metadata_tmp". 
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' @md
#' @export
convert_metadata = function (metadata,
                             metadata_yml_path) {
    res = convert_metadata_hide(metadata=metadata)
    res = format_metadata_res(res)

    typeName = res$meta$typeName
    Ok = typeName == "newline"
    res$meta$typeName[Ok] = paste0(typeName[Ok],
                                   res$meta$group_index[Ok])
    
    group_order = res$meta$group
    Ok = is.na(group_order)
    group_order[Ok] = res$meta$typeName[Ok]
    group_order = unique(group_order)
    
    meta_list = as.list(dplyr::group_split(res$meta, group))
    names(meta_list) = unique(unlist(sapply(meta_list, "[[", "group")))
    meta = list()
    nItem = length(meta_list)
    
    for (i in 1:nItem) {

        item = meta_list[[i]]
        name = names(meta_list)[i]
        
        if (is.na(name)) {
            item_list = as.list(tibble::deframe(dplyr::select(item,
                                                              typeName,
                                                              value)))
            meta = append(meta, item_list)
                          
        } else {
            item_list = 
                dplyr::summarise(dplyr::group_by(item,
                                                 group_index),
                                 value=list(tibble::deframe(pick(typeName,
                                                                 value))),
                                 .groups="drop")
            item_list = lapply(item_list$value, as.list)
            meta = append(meta, list(item_list))
            names(meta)[length(meta)] = name
        }
    }

    meta = meta[group_order]
    yaml_text = yaml::as.yaml(meta)
    Lines = strsplit(yaml_text, "\n")[[1]]
    # yaml::write_yaml(meta, metadata_yml_path)
    # Lines = readLines(metadata_yml_path)
    Ok = grepl("^newline[[:digit:]]+[:]", Lines)
    Lines[Ok] = ""
    Lines = Lines[c(TRUE, Lines[-1] != Lines[-length(Lines)])]    
    header_path = system.file("header.txt", package="dataverseuR")
    header = readLines(header_path)
    Lines = c(header, Lines)
    writeLines(Lines, metadata_yml_path)

    # Lines = dplyr::mutate(Lines, 
    #                       line=ifelse(
    #                           is.na(value), "",
    #                           paste0(environment_name,
    #                                  "$", typeName,
    #                                  " = \"",
    #                                  value, "\"")))
    # Lines = Lines$line
    
    # metadata_R_path = paste0(file_name, ".R")
    # metadata_json_path = paste0(file_name, ".json")
    # writeLines(Lines, metadata_R_path)

    # json = jsonlite::toJSON(metadata,
    #                         pretty=TRUE,
    #                         auto_unbox=TRUE)
    # write(json, metadata_json_path)
}
