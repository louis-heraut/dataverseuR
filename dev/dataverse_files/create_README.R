
README = readLines("README_template_en.txt")

nchar_line = 80
TODAY = Sys.Date()

README = gsub("[{]TODAY[}]", TODAY, README)



RDG_datadir = "to"
RDG_TITLE = "Suspended sand measurements in the Isere River catchment for sampler comparison"
RDG_DOI = "https://doi.org/10.57745/5EBITB"
RDG_CITATION = ""
RDG_CONTACT_EMAIL = c("guillaume.dramais@inrae.fr", "test")
RDG_PUBLICATION = "Marggraf, Jessica (in prep.), Evaluation of Delft Bottle and Pump Point-samplers for Characterizing Sand Suspension in Rivers, Water Resources Research."




cut_line = function (line_title, line_content, indent=0, nchar_line=80) {
    if (nchar(line_title) > 0) {
        if (grepl("[-]", line_title)) {
            line_title = paste0(strrep(" ", indent), "- ")
        } else {
            line_title = paste0(strrep(" ", indent), line_title, ": ")
        }
    }

    result = paste0(line_title, line_content) 
    if (nchar(result) > nchar_line) {
        line_content = paste0(paste0(strrep(" ", indent), "  ",
                                     strwrap(line_content,
                                             width=nchar_line-2-indent)),
                              collapse="\n")
        result = paste0(line_title, ">\n",
                        line_content) 
    }
    return (result)
}


format_yml = function (line_title, line_content, indent=0, nchar_line=80) {

    n_title = length(line_title)
    n_content = length(line_content)

    if (n_title == 1 & n_content == 1) {
        result = cut_line(line_title, line_content, indent, nchar_line)
    } else if (n_title == 1 & n_content > 1) {
        result = paste0(strrep(" ", indent), line_title, ": ")
        for (i in 1:n_content) {
            l_content = line_content[i]
            l_content = cut_line("- ", l_content, indent+2, nchar_line)
            result = paste0(result, "\n", l_content)
        }
    } else if (n_title > 1 & n_title == n_content) {
        result = paste0(mapply(cut_line, line_title,
                               line_content, indent, nchar_line),
                        collapse="\n")
    } else {
        stop()
    }
    
    return (result)
}



get_info_dir = function(path) {
    paths = list.files(path,
                       recursive=TRUE,
                       all.files=FALSE,
                       full.names=TRUE)
    n_files = sum(file.info(paths)$isdir == FALSE, na.rm=TRUE)
    n_dirs = sum(file.info(paths)$isdir == TRUE, na.rm=TRUE)
    
    info = sprintf(
        "%d directory%s, %d file%s",
        n_dirs,
        ifelse(n_dirs == 1, "", "ies"),
        n_files,
        ifelse(n_files == 1, "", "s"))
    
    return (info)
}


title = format_yml("Dataset title", RDG_TITLE, 0, nchar_line)
README = gsub("[{]TITLE[}]", title, README)

doi = format_yml("DOI", RDG_DOI, 0, nchar_line)
README = gsub("[{]DOI[}]", doi, README)

citation = format_yml("Citation", RDG_CITATION, 0, nchar_line)
README = gsub("[{]CITATION[}]", citation, README)

email = format_yml("Contact email", RDG_CONTACT_EMAIL,
                   0, nchar_line)
README = gsub("[{]EMAIL[}]", email, README)

publication = format_yml("Related publication",
                         RDG_PUBLICATION,
                         0, nchar_line)
README = gsub("[{]PUBLICATION[}]", publication, README)

tree = capture.output(fs::dir_tree(RDG_datadir))
# TREE[1] = "."
tree = c(tree, get_info_dir(RDG_datadir))
tree = paste0(tree, collapse="\n")
README = gsub("[{]TREE[}]", tree, README)



Paths = list.files(RDG_datadir, pattern="*.csv", full.names=TRUE) 
nPaths = length(Paths)

data_info = c()

for (i in 1:nPaths) {
    path = Paths[i]
    data = ASHE::read_tibble(path)
    RDG_FILE_DESCRIPTION = "aaa"

    subsection = paste0("## File ", i)
    n_underscore = max(nchar_line - nchar(subsection) - 1, 0)
    subsection = paste0(subsection, " ",
                        paste0(rep("_", n_underscore), "",
                               collapse=""))

    filename = paste0("Filename: ", basename(path))
    dirpath = paste0("Path: ", dirname(path))
    description = format_yml("Description", RDG_FILE_DESCRIPTION,
                             0, nchar_line)

    column_info_list =
        paste0("- displayed_name: ", names(data), "
  long_name: <full “human readable” name>
  description:
  type: ", sapply(data, class), "
  unit: <if applicable>
  allowed_values: <list of possible values>")
    column_info_list = paste0(column_info_list, collapse="\n\n")
    column_info = paste0("Column information:\n\n",
                         column_info_list)
    
    missing = paste0("Missing data codes: ", "NA")
    add_info = paste0("Additional information:")
    
    content = paste(filename,
                    dirpath,
                    description,
                    column_info,
                    missing,
                    add_info,
                    sep="\n\n")

    file_info =
        paste0(subsection, "\n", content)
    data_info = c(data_info, file_info)
}

data_info = paste0(data_info, collapse="\n\n")

README = gsub("[{]DATA[}]", data_info, README)


writeLines(README, "README_tmp.txt")
