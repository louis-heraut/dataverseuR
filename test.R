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


# devtools::load_all(".")
source("R/api.R")
source("R/dataverseur.R")

dotenv::load_dot_env(file=".env-entrepot")
# dotenv::load_dot_env(file=".env-demo")



to_do = c(
    "search_datasets"
    # "create_dataset"
    # "modify_dataset"
    # "add_files"
    # "delete_files"
    # "delete_dataset"
    # "publish_dataset"
    # "get_metrics"
)


if ("search_datasets" %in% to_do) {

    cols = c("dataset_DOI",
             "url",
             "name",
             "citation",
             "description",
             "identifier_of_dataverse",
             "subjects",
             "keywords",
             "fileCount",
             "createdAt",
             "authors")
    
    query = '(title:"Fiches de résultats*" OR title:"Fiches incertitudes*" OR title:"Fiches de diagnostic*" OR title:"Ensemble des fiches") NOT title:"Notice" NOT title:"Accompagnement"'
    publication_status = "RELEASED"
    type = "dataset"
    n_search = 1000
    
    datasets_search =
        search(query=query,
               publication_status=publication_status,
               type=type,
               dataverse="explore2",
               n_search=n_search)
    
    datasets_info = convert_datasets_search_to_tibble(datasets_search)
    datasets_info$name
}



if ("create_dataset" %in% to_do) {
    initialise_metadata()
    source("dataset_template.R")
    res = generate_metadata()
    dataset_DOI = create_dataset(dataverse="explore2",
                                 metadata_path=res$file_path)
}

if ("modify_dataset" %in% to_do) {
    initialise_metadata()
    source("dataset_template.R")
    META$title = gsub("XXX", "Rhône", META$title)
    res = generate_metadata()
    dataset_DOI = modify_dataset_metadata(dataverse="explore2",
                                          dataset_DOI=dataset_DOI,
                                          metadata_path=res$file_path)
}

if ("add_files" %in% to_do) {
    add_dataset_files(dataset_DOI=dataset_DOI,
                      paths="LICENSE")
}

if ("delete_files" %in% to_do) {
    delete_dataset_files(dataset_DOI=dataset_DOI)
}

# if ("delete_dataset" %in% to_do) {
#     delete_dataset(dataset_DOI=dataset_DOI)
# }


if ("publish_dataset" %in% to_do) {
    publish_dataset(dataset_DOI, type="major")
}



# datasets_DOI = get_DOI_from_datasets_search(datasets_search)
# dataset_DOI = datasets_DOI[1]
# metadata = get_dataset_metadata(dataset_DOI=dataset_DOI)


# json = jsonlite::toJSON(metadata,
#                  pretty=TRUE,
#                  auto_unbox=TRUE)
# write(json, "tmp.json")

# convert_metadata(metadata)


# flatten_tibble = function (tbl, delimiter="; ") {
#     tbl = dplyr::mutate(tbl,
#                         across(everything(),
#                                ~ ifelse(
#     purrr::map_lgl(.x, is.list),
#     purrr::map_chr(.x, ~paste(unlist(.x),
#                               collapse=delimiter)),
#     .x)))
#     return (tbl)
# }



if ("get_metrics" %in% to_do) {
    # datasets_DOI = get_DOI_from_datasets_search(datasets_search)
    datasets_metrics = get_datasets_metrics(datasets_info$dataset_DOI)
    datasets_info = dplyr::full_join(datasets_info, datasets_metrics,
                                     by="dataset_DOI")

    datasets_size = get_datasets_size(datasets_info$dataset_DOI)
    datasets_info = dplyr::full_join(datasets_info, datasets_size,
                                     by="dataset_DOI")
    
    ASHE::write_tibble(datasets_info,
                       path="datasets_info.csv")
}
