## This function is similar to the get_json function, except this function will save it as a json file

write_json_file <- function(concept_set, path, condition_name) {
  jsontext <- jsonlite::toJSON(
    list(
      items = list(
        list(
          concept = concept_set,
          isExcluded = FALSE,
          includeDescendants = TRUE,
          includeMapped = TRUE
        )
      )
    ),
    pretty = T, auto_unbox = T
  )
  filename <- paste0(condition_name, "_concept_set.json")
  return(
    write(jsontext, paste0(path, filename))
  )
}
