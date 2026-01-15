
url = "https://qudt.org/3.1.9/vocab/unit"
qudt_ttl_file = "qudt-unit-3.1.9.ttl"


qudt_csv_raw_file = gsub(".ttl", "_raw.csv", qudt_ttl_file)
qudt_csv_file = gsub(".ttl", ".csv", qudt_ttl_file)


if (!file.exists(qudt_ttl_file)) {
    download.file(url=url,
                  destfile=qudt_ttl_file,
                  method="curl",
                  extra="-H 'Accept: text/turtle'")
}


if (!file.exists(qudt_csv_raw_file)) {
    qudt = rdf_parse(qudt_ttl_file, format="turtle")

    query = "
PREFIX qudt: <http://qudt.org/schema/qudt/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dcterms: <http://purl.org/dc/terms/>

SELECT ?unit ?label ?lang ?symbol ?ucum ?description
WHERE {
  ?unit a qudt:Unit .
  OPTIONAL { ?unit rdfs:label ?label . BIND(LANG(?label) AS ?lang) }
  OPTIONAL { ?unit qudt:symbol ?symbol }
  OPTIONAL { ?unit qudt:ucumCode ?ucum }
  OPTIONAL { ?unit dcterms:description ?description }
}
"
    units = rdf_query(qudt, query)
    write.csv(units, qudt_csv_raw_file)
}


if (!file.exists(qudt_csv_file)) {
    units = dplyr::tibble(read.csv(qudt_csv_raw_file))
    units = dplyr::filter(units, lang %in% c("fr", "en"))

    units = dplyr::rename(units, URI=unit)
    units = tidyr::pivot_wider(units,
                               id_cols=c(URI, symbol,
                                         ucum, description),
                               names_from=lang, values_from=label,
                               names_prefix="label_")
    units = dplyr::relocate(units, label_en, .before=description) 
    units = dplyr::relocate(units, label_fr, .before=description)

    replace_arc_hide = function(x) {
        if (grepl("'", x)) {
            parts = stringr::str_split(x, "\\[[^]]+\\]", simplify=FALSE)[[1]]
            brackets = stringr::str_extract_all(x, "\\[[^]]+\\]")[[1]]
            result = character(0)
            b_idx = 1
            for (i in seq_along(parts)) {
                part = parts[i]
                if (nchar(part) > 0) {
                    part = stringr::str_replace_all(part, "''", "arcsec")
                    part = stringr::str_replace_all(part, "'", "arcmin")
                    result = c(result, part)
                }
                if (b_idx <= length(brackets)) {
                    result = c(result, brackets[b_idx])
                    b_idx = b_idx + 1
                }
            }
            x = paste0(result, collapse="")
        }
        return (x)
    }

    replace_arc = function (x) {
        x = sapply(x, replace_arc_hide)
        return (x)
    }

    bracket_to_upper_hide = function(x) {
        content = stringr::str_sub(x, 2, -2)
        content = stringr::str_replace_all(x, "\\'", "")
        parts = stringr::str_split(content, "_", simplify=TRUE)
        if(length(parts) > 1) {
            parts[-1] = toupper(parts[-1])
        }
        x = paste0(parts, collapse="")
        return (x)
    }

    bracket_to_upper = function (x) {
        x = stringr::str_replace_all(x, "\\[[^]]+\\]", bracket_to_upper_hide)
        return (x)
    }

    curly_to_camel = function (x) {
        x = stringr::str_replace_all(x, "\\{([^}]+)\\}", function(m) {
            x = stringr::str_to_title(stringr::str_sub(m, 2, -2))
        })
    }

    replace_per = function(x) {
        x = stringr::str_replace(x,
                                 "^(?=[A-Za-z0-9]+-[0-9]+)",
                                 "_per_")
        x = stringr::str_replace(x,
                                 "\\.(?=[A-Za-z0-9]+-[0-9]+)",
                                 "_per_")
        return(x)
    }

    remove_minus_after_per_hide = function (x) {
        if (grepl("_per_", x)) {
            parts = stringr::str_split_fixed(x, "_per_", 2)
            first = parts[, 1]
            second = parts[, 2]
            second = stringr::str_replace_all(second, "-1", "")
            second = stringr::str_replace_all(second, "-", "")
            x = paste0(first, "_per_", second)
        }
        return (x)
    }

    remove_minus_after_per = function (x) {
        x = sapply(x, remove_minus_after_per_hide, USE.NAMES=FALSE)
        return (x)
    }

    to_ucum_slug = function (x) {
        x = ifelse(is.na(x), NA_character_, x)
        x = stringr::str_replace_all(x, "\\{\\#\\}", "Num")
        x = stringr::str_replace_all(x, "\\%", "pct")
        x = replace_arc(x)
        x = bracket_to_upper(x)
        x = stringr::str_replace_all(x, "\\[|\\]", "")
        x = curly_to_camel(x)
        x = replace_per(x)
        x = remove_minus_after_per(x)
        x = stringr::str_replace_all(x, "^\\_", "")
        x = stringr::str_replace_all(x, "\\.", "_")
        return (x)
    }

    units$ucum_slug = to_ucum_slug(units$ucum)
    units = dplyr::relocate(units, ucum_slug, .after=ucum)
    write.csv(units, qudt_csv_file)
}
