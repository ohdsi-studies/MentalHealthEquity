library('httr')
library('rjson')

#' Takes a valid OMOP Concept ID and returns a list of concept fields
#'
#' @param id Integer representing an OMOP Concept ID
#'
#' @return list Fields related to the concept 
#'
#' @examples
#' get_concept(436665)
#'
#' @export
get_concept <- function(id) {
  url <- paste0("http://atlas-demo.ohdsi.org/WebAPI/vocabulary/concept/", id)
  result <- GET(url)
  return(httr::content(result, "parsed"))
}

## This function takes in the concept set, and it returns the JSON file with the proper querying format
## the proper format is given above but also in the bipolar_disorder_concept_set.json

get_json <- function(concept_set) {
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
  return(jsontext)
}

#### Getting all the relevant concept IDs related to each condition ####
# this function will take in the condition:
# bipolar_disorder, depression, or suicidality
# it will return the response object and retrieve all of the concept IDs

get_cohort <- function(condition) {
  condition <- substitute(condition)
  filename <- paste0("../data/exp_raw/concept_sets/", condition, "_concept_set.json")
  condition_json <- fromJSON(file = filename)
  concept_set_url <- "http://atlas-demo.ohdsi.org/WebAPI/vocabulary/resolveConceptSetExpression/"
  cohort <- POST(concept_set_url, body = condition_json, encode = "json")
  return(cohort)
}

## Looping through the concept IDs and getting the json and writing it to a csv
# this function takes in a cohort from the get_cohort function
# and it returns the dataframe all the concept sets in the condition code

get_concept_set <- function(cohort) {
  cohort_list <- list()
  for (i in 1:length(content(cohort))) {
    concept_id <- content(cohort)[i]
    url_base <- "http://atlas-demo.ohdsi.org/WebAPI/vocabulary/concept/"
    url <- paste0(url_base, concept_id, "/")
    result <- GET(url)
    df <- data.frame(content(result))
    cohort_list[[i]] <- df
  }
  concept_set_df <- do.call(rbind, cohort_list)
  return(concept_set_df)
}
