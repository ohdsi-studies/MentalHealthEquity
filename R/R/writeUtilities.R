## This function is similar to the get_json function, except this function will save it as a json file

write_json_file <- function(concept_set) {
  if (concept_set$CONCEPT_ID == 436665) {
    condition <- "bipolar_disorder"
  } else if (concept_set$CONCEPT_ID == 440383) {
    condition <- "depression"
  } else if (concept_set$CONCEPT_ID == 4273391) {
    condition <- "suicidality"
  } else {
    condition <- "INVALID"
  }
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
  filename <- paste0(condition, "_concept_set.json")
  path <- "../data/exp_raw/concept_sets/"
  return(
    write(jsontext, paste0(path, filename))
  )
}
