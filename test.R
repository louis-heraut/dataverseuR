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


devtools::load_all(".")
source("R/api.R")
source("R/dataverseur.R")

dotenv::load_dot_env(file=".env-entrepot")
# dotenv::load_dot_env(file=".env-demo")



to_do = c(
    # "search",
    "create_dataset"
    # "modify_dataset"
    # "add_files"
    # "delete_files"
    # "delete_dataset"
    # "publish_dataset"
)


if ("search" %in% to_do) {
    query = "*"
    publication_status =
        "RELEASED"
    # "DRAFT"
    type = "dataset"
    dataverse = "riverly"
    n_search = 1000
    
    datasets = search(query=query,
                      publication_status=publication_status,
                      type=type,
                      dataverse=dataverse,
                      n_search=n_search)
    datasets
}

if ("create_dataset" %in% to_do) {
    initialise_metadata()
    source("dataset_template.R")
    res = generate_metadata()
    dataset_DOI = create_dataset(dataverse="explore2",
                                 metadata_path=res$path)
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
