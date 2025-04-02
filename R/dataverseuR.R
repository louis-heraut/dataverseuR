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


#' @title initialise_metadata
#' @description Create an empty R variable metadata environment in which all assigned R variables will represent a dataverse metadata for a unique dataset. See [generate_metadata()] to create the associated json metadata file.
#' @param environment_name A character string representing the name of the R variable metadata environment to be created. The default value is `"META"`.
#' @examples
#' a
#' @export
#' @md
initialise_metadata = function (environment_name="META") {
    assign(environment_name, new.env(), envir=as.environment(1))
}


replicate_typeName = function (metadata, typeName, n) {
    if (is.list(metadata)) {
        return (lapply(metadata, function(x) {

            if ("value" %in% names(x) && is.list(x$value)) {
                # if (typeName %in% names(x$value)) {
                #     tmp = x$value
                #     tmp_all = list()
                #     for (i in 1:n) {
                #         for (tp in names(x$value)) {
                #             tmp[[tp]]$typeName =
                #                 paste0(x$value[[tp]]$typeName, i)
                #         }
                #         tmp_all = append(tmp_all, list(tmp))
                #     }
                #     x$value = tmp_all
                # }
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
#' @examples
#' a
#' @export
#' @md
generate_metadata = function (metadata_dir=".",
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


# convert_metadata_hide = function (metadata,
#                                   environment_name,
#                                   Lines) {
#     if (is.list(metadata)) {
#         return (lapply(metadata, function(x) {
            
#             if ("typeName" %in% names(x) &
#                 "value" %in% names(x)) {
#                 if (!is.list(x$value) & !is.na(x$value)) {
#                     # print(paste0(x$typeName, " : ", x$value))
#                     line = paste0(environment_name, "$", x$typeName,
#                                   " = \"", x$value, "\"")
#                     Lines = c(Lines, line)
#                 }
#             }
#             Lines = convert_metadata_hide(x,
#                                           environment_name,
#                                           Lines)
#             return (Lines)
#         }))
#     }
# }

insert_spaces = function(to_space, with_order) {
    spaced = c(to_space[1])
    for (i in 2:length(with_order)) {
        if (with_order[i] != with_order[i - 1]) {
            spaced = c(spaced, "")
        }
        spaced = c(spaced, to_space[i])
    }
    return (spaced)
}


insert_spaces <- function(vec2, vec1) {
    vec2_spaced <- c(vec2[1])
    for (i in 2:length(vec1)) {
        if (vec1[i] != vec1[i - 1]) {
            vec2_spaced <- c(vec2_spaced, "")  # Insert a space
        }
        vec2_spaced <- c(vec2_spaced, vec2[i])  # Add the current element
    }
    
    return(vec2_spaced)
}



convert_metadata_hide = function(metadata, environment_name,
                                 Lines, previous) {
    if (is.list(metadata)) {
        for (x in metadata) {

            if ("typeName" %in% names(x) & "value" %in% names(x)) {
                if (is.character(x$value)) {
                    following = gsub("[[:upper:]].*", "", x$typeName)
                    following = following[!is.na(following)]

                    # TypeNames = gsub(".*[$]", "", Lines_tmp)
                    # TypeNames = gsub(" [=].*", "", TypeNames)
                    # TypeNames_noNum = gsub("[[:digit:]]+", "",
                    #                        TypeNames)
                    # TypeNames_Num = stringr::str_extract("[[:digit:]]+",
                    #                                      TypeNames)

                    # typeName = gsub(".*[$]", "", line)
                    # typeName = gsub(" [=].*", "", typeName)

                    # Ok = TypeNames_noNum %in% typeName[1] &
                    #     TypeNames_noNum != ""

                    # print(typeName)
                    # print(TypeNames)
                    # print(TypeNames_noNum)
                    # print(TypeNames_Num)
                    # print("")
                    
                    # if (any(Ok)) {
                    #     if (all(is.na(TypeNames_Num[Ok]))) {
                    #         typeName = paste0(typeName, "1")
                    #     } else {
                    #         typeName = paste0(typeName,
                    #                           max(TypeNames_Num[Ok],
                    #                               na.rm=TRUE)+1)
                    #     }
                    #     LinestypeName
                    # }




                    line = paste0(environment_name, "$",
                                  x$typeName, " = \"",
                                  x$value, "\"")

                    if (previous[1] == following[1]) {
                        Lines = c(Lines, line)
                    } else {
                        Lines = c(Lines, "", line)
                    }
                    previous = following
                }
            }
            Lines = convert_metadata_hide(x, environment_name,
                                          Lines, previous)
        }
    }
    return (Lines)
}


#' @title convert_metadata
#' @export
#' @md
convert_metadata = function (metadata,
                             environment_name="META") {
    Lines = c()
    Lines = convert_metadata_hide(metadata=metadata,
                                  environment_name=environment_name,
                                  Lines=Lines,
                                  previous="")
    writeLines(Lines, "tmp.R")
}


