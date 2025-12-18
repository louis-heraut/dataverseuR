
nchar_line = 80
today = Sys.Date()

header = paste0(
r"( ___  ___    _    ___   __  __  ___ 
| _ \| __|  /_\  |   \ |  \/  || __|
|   /| _|  / _ \ | |) || |\/| || _|   RDG x RiverLy README File Template
|_|_\|___|/_/ \_\|___/ |_|  |_||___|  English - Version: 1 (2025-12-15)

This README file was automatically generated on )",
Sys.Date(), " by Louis Héraut.
Last update: ", Sys.Date() , ".")



RDG_TITLE = "Suspended sand measurements in the Isere River catchment for sampler comparison"
RDG_DOI = "https://doi.org/10.57745/5EBITB"
RDG_CITATION = ""
RDG_CONTACT_EMAIL = c("guillaume.dramais@inrae.fr", "test")
RDG_PUBLICATION = "Marggraf, Jessica (in prep.), Evaluation of Delft Bottle and Pump Point-samplers for Characterizing Sand Suspension in Rivers, Water Resources Research."



cut_line = function (line_title, line_content, nchar_line) {
    line = paste0(line_title, ": ", line_content)
    if (nchar(line) > nchar_line) {
        line_content = paste0(paste0("  ",
                                     strwrap(line_content,
                                             width=nchar_line-2)),
                              collapse="\n")
        line = paste0(line_title, ": >\n",
                      line_content)
    }
    return (line)
}

section = "# GENERAL INFORMATION __________________________________________________________"

title = cut_line("Dataset title", RDG_TITLE, nchar_line)
doi = paste0("DOI: ", RDG_DOI)
citation = cut_line("Citation", RDG_CITATION, nchar_line)

if (length(RDG_CONTACT_EMAIL) == 1) {
    email = paste0("Contact email: ", RDG_CONTACT_EMAIL)
} else {
    email = paste0("Contact email:\n",
                   paste0(paste0("  - ", RDG_CONTACT_EMAIL),
                          collapse="\n"))
}

# if more than one
publication = cut_line("Related publication", RDG_PUBLICATION, nchar_line)

content = paste(title,
                doi,
                citation,
                email,
                publication,
                "<Remove or add any section if applicable>", 
                sep="\n\n")
    
general_info =
    paste0(section, "\n", content)



methodo_info =
    "# METHODOLOGICAL INFORMATION ___________________________________________________
## Environmental/experimental condition ________________________________________

## Description of sources and methods used to collect and generate data ________
# <If applicable, describe standards, calibration information, facility
# instruments, etc.>

## Methods for processing the data _____________________________________________
# <If applicable, describe how submitted data were processed and include details
# that may be important for data reuse or replication. Add comments to explain
# each step taken. For example, include data cleaning and analysis methods; code
# and/or algorithms, de-identification procedures for sensitive data human
# subjects or endangered species data.>
 
## Quality-assurance procedures performed on the data __________________________

## Other contextual information ________________________________________________
# <Any information that you consider important for the evaluation of the
# dataset’s quality and reuse thereof: for example, information about the
# software required to interpret the data. If applicable and not covered above,
# include full name and version of software, and any necessary packages or
# libraries needed to read and interpret the data, *e.g.* to run scripts.>"



"# DATA & FILE OVERVIEW _________________________________________________________
## File hierarchy convention ___________________________________________________
.
├── data-additional_Beverage-and-Williams-1989_sand-flux_125-250-micrometre_Colorado-Mississippi.csv
├── data-additional_Beverage-and-Williams-1989_sand-flux_62-125-micrometre_Colorado-Mississippi.csv
├── data-additional_Beverage-and-Williams-1989_sand-flux_62-larger-micrometre_Colorado-Mississippi.csv
├── data-additional_Dijkman-and-Milisic-1982.csv
├── data-additional_Florian-Benoit-2025.csv
├── data-additional_Samuel-Payen_field.csv
├── data-additional_Samuel-Payen_lab.csv
├── data-comparison_pump-PP36_vs_DB_point_Grenoble-Campus.csv
├── data-comparison_pump-PP36_vs_US-P-6_cross-section_Grenoble-Campus.csv
├── data-comparison_pump-PP36_vs_US-P-6_grain-size-distribution_all-sites.csv
├── data-comparison_pump-PP36_vs_US-P-6_point_all-sites.csv
├── data-gaugings_DB_localisation.csv
├── data-gaugings_US-P-6_localisation.csv
└── meta_cross-section-area_Grenoble-Campus.csv
1 directory, 14 files

## File naming convention ______________________________________________________
### data-additional:
No naming convention

### data-comparison:
data-comparison_{1}_vs_{2}_{3}_{4}.csv
{1} first sampler type:
  -- pump-PP36
{2} second sampler type:
  -- DB (Delft bottle) 
  -- US-P-6
{3} measurement type:
  -- point (point sand concentration)
  -- cross-section (cross-sectional averages of sand concentration)
  -- grain-size-distribution (point grain size distribution)
{4} localisation:
  -- all-sites
  -- Grenoble-Campus (Isère River at Grenoble Campus)
  -- Chamousset (Arc River at Chamousset)
  -- Pont-Rouge (Romanche River at Pont Rouge)


## Additional information ______________________________________________________"




section = "# DATA-SPECIFIC INFORMATION ____________________________________________________"

Paths = list.files("to", pattern="*.csv", full.names=TRUE) 
nPaths = length(Paths)

data_info = c()

for (i in 1:nPaths) {
    path = Paths[i]
    data = ASHE::read_tibble(path)

    subsection = paste0("## File ", i)
    n_underscore = max(nchar_line - nchar(subsection) - 1, 0)
    subsection = paste0(subsection, " ",
                        paste0(rep("_", n_underscore), "",
                               collapse=""))

    filename = paste0("Filename: ", basename(path))
    dirpath = paste0("Path: ", dirname(path))
    description = paste0("Description: ")

    column_info_list =
        paste0("- displayed name : ", names(data), "
  long_name: <full “human readable” name>
  description:
  type: ", sapply(data, class), "
  unit: <if applicable>
  allowed_values: <list of possible values>")
    column_info_list = paste0(column_info_list, collapse="\n\n")
    column_info = paste0("Column information:\n\n",
                         column_info_list)
    
    missing = paste0("Missing data codes:", "NA")
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
data_info = paste0(section, "\n", data_info)


README = paste(header,
               general_info,
               methodo_info,
               data_info,
               sep="\n\n\n")


writeLines(README, "README_tmp.txt")
