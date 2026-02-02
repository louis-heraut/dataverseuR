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


check_yml_format = function (path) {
    if (!grepl("\\.ya?ml$", path)) {
        stop(paste0(basename(path), " is not a YAML file."))
    }
}


check_json_format = function (path) {
    if (!grepl("\\.json$", path, ignore.case=TRUE)) {
        stop(paste0(basename(path), " is not a JSON file."))
    }
}


check_dir = function (path) {
    if (!dir.exists(dirname(path))) {
        dir.create(dirname(path), recursive=TRUE)
    }
}


# Fonction pour sanitizer les DOI en noms de dossiers
sanitize_doi = function(doi) {
    sanitized = gsub(":", "_", doi)
    sanitized = gsub("/", "_", sanitized)
    sanitized = gsub("\\.", "-", sanitized)
    return (sanitized)
}
