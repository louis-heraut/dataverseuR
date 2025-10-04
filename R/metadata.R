# Copyright 2025 Louis Héraut (louis.heraut@inrae.fr)*1
#
# *1   INRAE, France
#
# This file is part of dataverseuR R package.
#
# dataverseuR R package is free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# dataverseuR R package is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU xGeneral Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with dataverseuR R package.
# If not, see <https://www.gnu.org/licenses/>.


format_full_metadata_hide = function(metadata) {
    if (is.list(metadata)) {
        return(lapply(metadata, function(x) {
            if ("multiple" %in% names(x) && x$multiple) {
                x$value = x$value[1]
                # x$multiple = FALSE
            }
            if ("value" %in% names(x) && is.character(x$value)) {
                if (x$multiple) {
                    x$value = list()
                } else {
                    x$value = ""
                }
            }
            x[] = format_full_metadata_hide(x)
            return(x)
        }))
    }
    return(metadata)
}


format_full_metadata = function (file="rechercheDataGouv-full-metadata.json",
                                 dev=FALSE) {

    if (dev) {
        path = file.path("inst", "extdata", file)
    } else {
        path = system.file("extdata", file, package="dataverseuR")
    }
    metadata = jsonlite::fromJSON(path, simplifyDataFrame=FALSE)
    
    metadata = format_full_metadata_hide(metadata)

    if (dev) {
        full_template_path = file.path("inst", "extdata",
                                       "RDG_full_metadata_template.json")
    } else {
        full_template_path = system.file("extdata",
                                         "RDG_full_metadata_template.json",
                                         package="dataverseuR")
    }
    write(jsonlite::toJSON(metadata,
                           pretty=TRUE,
                           auto_unbox=TRUE),
          full_template_path)
}


replicate_typeName = function (metadata, typeName, n) {
    if (is.list(metadata)) {
        return (lapply(metadata, function(x) {

            if ("value" %in% names(x) && is.list(x$value)) {
                ok = FALSE
                if (typeName %in% names(x$value)) {
                    ok = TRUE
                    tmp_save = x$value
                } else if (length(x$value) > 0 &&
                           typeName %in% names(x$value[[1]])) {
                    ok = TRUE
                    tmp_save = x$value[[1]]
                }
                if (ok) {
                    tmp = tmp_save
                    tmp_all = list()
                    for (i in 1:n) {
                        for (tp in names(tmp_save)) {
                            tmp[[tp]]$typeName =
                                paste0(tmp_save[[tp]]$typeName, i)
                        }
                        tmp_all = append(tmp_all, list(tmp))
                    }
                    x$value = tmp_all
                }
                
            }
            x[] = replicate_typeName(x, typeName, n)
            return (x)
        }))
    }
    return (metadata)
}

add_typeName = function (metadata, typeName, value) {
    if (is.list(metadata)) {
        return (lapply(metadata, function(x) {

            if ("typeName" %in% names(x)) {
                if (x$typeName == typeName) {
                    if (x$multiple) {
                        x$value = list(value)
                    } else {
                        x$value = value
                    }
                    if (grepl("[[:digit:]]+$", x$typeName)) {
                        x$typeName = gsub("[[:digit:]]+$", "",
                                          x$typeName)
                    }
                }
            }
            x[] = add_typeName(x, typeName, value)
            return (x)
        }))
    }
    return (metadata)
}


clean_metadata_hide = function (metadata) {
    tmpAll = c("value", "fields")

    if (is.list(metadata)) {
        return (lapply(metadata, function(x) {

            for (name in names(x)) {
                if (is.list(x[[name]])) {
                    get_n = function (xx) {
                        ok = tmpAll %in% names(xx)
                        if (any(ok)) {
                            tmp = tmpAll[ok]
                            if (is.character(xx[[tmp]])) {
                                n = nchar(xx[[tmp]])
                            } else {
                                n = 888
                            }
                        } else {
                            n = 999
                        }
                        return (n)
                    }

                    ok = names(x[[name]]) %in% tmpAll
                    if (sum(ok) == 1) {
                        tmp = names(x[[name]])[ok]
                        if (!is.list(x[[name]][[tmp]])) {
                            if (nchar(x[[name]][[tmp]]) == 0) {
                                x = x[names(x) != name]
                            }
                        }
                        
                    } else {
                        n = sapply(x[[name]], get_n)
                        if (all(n == 0)) {
                            x[[name]] = ""
                        } else {
                            x[[name]] = x[[name]][n > 0]
                        }
                    }
                }
            }
            if (length(x) == 0) {
                x = c(value="")
            }
            x[] = clean_metadata_hide(x)
            return (x)
        }))
    }
    return (metadata)
}



clean_metadata = function (metadata) {
    get_condition = function (x) {
        if (is.list(x$fields)) {
            ok = any(nchar(unlist(x$fields)) == 0)
        } else {
            ok = x$fields == ""
        }
    }
    ok = any(sapply(metadata$datasetVersion$metadataBlocks,
                    get_condition))
    while (ok) {
        metadata = clean_metadata_hide(metadata)
        ok = any(sapply(metadata$datasetVersion$metadataBlocks,
                        get_condition))
    }
    return (metadata)
}




generate_metadata_hide = function(metadata_yml,
                                  res=list(group=c(),
                                           meta=dplyr::tibble())) {
    if (is.list(metadata_yml)) {
        for (i in 1:length(metadata_yml)) {
            typeName = names(metadata_yml)[i]
            value = metadata_yml[[i]]
            if (is.character(value)) {
                line = dplyr::tibble(typeName=typeName,
                                     value=value)
                res$meta = dplyr::bind_rows(res$meta,
                                            line)
            } else if (is.list(value)) {
                res$group = c(res$group, typeName)
            }
            res = generate_metadata_hide(value, res)
        }
    }
    return (res)
}

format_metadata_res = function (res) {
    res$meta$group = NA
    for (group in res$group) {
        res$meta$group[grepl(group, res$meta$typeName)] = group 
    }
    res$meta =
        dplyr::mutate(dplyr::group_by(res$meta, typeName),
                      group_index=ifelse(
                          !is.na(typeName) &
                          dplyr::n() > 1,
                          dplyr::row_number(),
                          NA))
    res$meta = dplyr::ungroup(res$meta)
    return (res)
}


#' @title generate_metadata
#' @description Write a metadata json file and return the associated metadata list based on the R variables contained in the previously initialised R variable metadata environment. See [initialise_metadata()] to create a new R variable environment.
#' @param overwrite_metadata A logical value indicating whether to overwrite an existing metadata file. Defaults to TRUE.
#' @return A list containing two elements :
#' - `metadata_path` the path to the generated metadata file and
#' - `json` the json list equivalent content of the metadata
#' @seealso
#' - [dataverseuR GitHub documentation](https://github.com/super-lou/dataverseuR) <https://github.com/super-lou/dataverseuR>
#' @md
#' @export
generate_metadata = function (metadata_yml_path,
                              overwrite_metadata=TRUE) {

    full_template_path =
        system.file("extdata",
                    "RDG_full_metadata_template.json",
                    package="dataverseuR")
    
    metadata = jsonlite::fromJSON(full_template_path,
                                  simplifyVector=FALSE,
                                  simplifyDataFrame=FALSE)

    metadata_path = gsub(".yml", ".json", metadata_yml_path)
    metadata_yml = yaml::read_yaml(metadata_yml_path)

    res = generate_metadata_hide(metadata_yml)
    res = format_metadata_res(res)

    Ok = !is.na(res$meta$group_index)
    res$meta$typeName[Ok] = paste0(res$meta$typeName[Ok],
           res$meta$group_index[Ok])
    
    TypeNames = res$meta$typeName
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
        value = res$meta$value[res$meta$typeName == typeName]
        metadata = add_typeName(metadata, typeName, value)
    }
    metadata = clean_metadata(metadata)

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




convert_metadata_hide = function(metadata,
                                 res=list(group=c(),
                                          meta=dplyr::tibble()),
                                 previous="") {
    if (is.list(metadata)) {
        for (x in metadata) {

            if ("typeName" %in% names(x) &
                "value" %in% names(x)) {
                if (is.character(x$value)) {
                    following = gsub("[[:upper:]].*", "",
                                     x$typeName)
                    following = following[!is.na(following)]

                    line = dplyr::tibble(typeName=x$typeName,
                                         value=x$value)
                    if (previous[1] != following[1]) {
                        empty = dplyr::tibble(typeName="newline",
                                              value="")
                        res$meta =
                            dplyr::bind_rows(res$meta,
                                             empty)
                    }
                    res$meta = dplyr::bind_rows(res$meta,
                                                line)
                    previous = following


                } else if (is.list(x$value)) {
                    res$group = c(res$group, x$typeName)
                }
            }
            res = convert_metadata_hide(x, res, previous)
        }
    }
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
}
