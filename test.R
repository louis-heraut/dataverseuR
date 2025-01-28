

devtools::load_all(".")
source("R/api.R")
source("R/dataverseur.R")

dotenv::load_dot_env(file=".env-entrepot")
# dotenv::load_dot_env(file=".env-demo")



to_do = c(
    # "search",
    # "create"
    # "modify"
    # "add_files"
    "delete_files"
    # "publish",
    # "delete"
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

if ("create" %in% to_do) {
    initialise_dataset()
    source("template_fiche_incertitude.R")
    res = generate_dataset(dev=TRUE)
    dataset_DOI = create_dataset(dataverse="explore2",
                                 metadata_path=res$path)
}

if ("modify" %in% to_do) {
    initialise_dataset()
    source("template_fiche_incertitude.R")
    DS$title = gsub("XXX", "Rhône", DS$title)
    res = generate_dataset(dev=TRUE)
    dataset_DOI = modify_dataset_metadata(dataset_DOI=dataset_DOI,
                                          metadata_path=res$path)
}

if ("add_files" %in% to_do) {
    add_dataset_files(dataset_DOI=dataset_DOI, paths="LICENSE")
}

if ("delete_files" %in% to_do) {
    delete_dataset_files(dataset_DOI=dataset_DOI)
}



stop()



if ("modify_incertitude_fiche" %in% to_do) {

    figure_path = "/home/lheraut/Documents/INRAE/projects/Explore2_project/Explore2_toolbox/figures/incertitude"
    fiche_dir = "fiche"
    notice_file = "Explore2_Notice_fiche_incertitude_VF.pdf"

    query = "Fiches incertitudes des modèles hydrologiques"

    publication_status =
        # "RELEASED"
        "DRAFT"
    type = "dataset"
    collection = "Explore2"
    n_search = 40

    # datasets = search(BASE_URL, API_TOKEN,
                      # query=query,
                      # publication_status=publication_status,
                      # type=type,
                      # collection=collection,
                      # n_search=n_search)
    # datasets_DOI = get_doi_from_datasets(datasets)

    for (i in 1:length(datasets_DOI)) {
        initialise_RDGf()
        source("template_fiche_incertitude.R")

        title = names(datasets_DOI)[i]
        region = gsub(".*[:] ", "", title)
        RDGf$title = title
        RDGf$dsDescriptionValue = gsub("XXX", region,
                                       RDGf$dsDescriptionValue)
        res = generate_RDGf(dev=TRUE)
        
        modify_dataset_metadata(BASE_URL,
                                API_TOKEN,
                                datasets_DOI[i],
                                res$path) 
    }
}






if ("add diagnostic" %in% to_do) {

    figure_dir = "/home/louis/Documents/bouleau/INRAE/project/Explore2_project/Explore2_toolbox/figures/diagnostic/Fiche_diagnostic_région"
    paths = list.files(figure_dir, recursive=TRUE, full.names=TRUE)
    paths = paths[!grepl("sommaire", paths)]

    name_paths = gsub("[/].*", "", gsub("^[/]", "", gsub(figure_dir, "", paths)))
    # name_paths = gsub("([(])|([)])", "", name_paths)
    # name_paths = gsub("é|è|ê", "e", name_paths)
    # name_paths = gsub("à", "a", name_paths)
    # name_paths = gsub("[']", "_", name_paths)
    # name_paths = gsub("ô", "o", name_paths)
    names(paths) = name_paths
    
    for (k in 1:length(datasets_DOI)) {
        dataset_name = names(datasets_DOI)[k]
        dataset_doi = datasets_DOI[k]

        add_dataset_files(BASE_URL, API_TOKEN, dataset_doi, paths=paths)
        if ("publish" %in% to_do) {
            publish_dataset(BASE_URL, API_TOKEN,
                            dataset_doi, type="major")
        }
    }
}


if ("add projection" %in% to_do) {

    figure_dir = "/home/louis/Documents/bouleau/INRAE/project/Explore2_project/Explore2_toolbox/figures/diagnostic/Fiche_diagnostic_région"
    figure_dirs = list.dirs(figure_dir, recursive=FALSE)
    figure_letters = substr(basename(figure_dirs), 1, 1)
    names(figure_dirs) = figure_letters
    
    for (k in 1:length(datasets_DOI)) {
        dataset_name = names(datasets_DOI)[k]
        dataset_doi = datasets_DOI[k]
        letter = gsub(".*[:][ ]", "", dataset_name)
        letter = substr(letter, 1, 1)
        dir = figure_dirs[names(figure_dirs) == letter]
        paths = list.files(dir, full.names=TRUE)
        print(letter)
        add_dataset_files(BASE_URL, API_TOKEN, dataset_doi,
                          paths=paths)
        if ("publish" %in% to_do) {
            publish_dataset(BASE_URL, API_TOKEN,
                            dataset_doi, type="major")
        }
    }
}
