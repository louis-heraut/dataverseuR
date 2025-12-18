

devtools::load_all("/home/lheraut/Documents/INRAE/projects/ASHE_project/ASHE")


Paths = list.files("from", pattern="*.txt", full.names=TRUE) 
output_Paths = gsub("from", "to", Paths)
output_Paths = gsub(".txt", ".csv", output_Paths)

A=mapply(convert_tibble,
         path=Paths,
         output_path=output_Paths,
         read_guess_sep=TRUE,
         read_guess_text_encoding=TRUE)


# sapply(Paths_csv, unlink)


