library("httr")
library("rjson")

#' Get Concept ID Details
#'
#' Takes a valid OMOP Concept ID and returns a list of concept fields
#'
#' @param id Integer representing an OMOP Concept ID
#'
#' @return Properly formatted json text related to the concept ID.
#' The json text is used for OHDSI Atlas queries
#'
#' @examples
#' ## Retrieves the json text for the concept ID 436665 (bipolar disorder)
#' bipolar_id <- 436665
#' get_atlas_concept(bipolar_id)
#' # {
#' # "items": [
#' #   {
#' #     "concept": {
#' #       "CONCEPT_ID": 436665,
#' #       "CONCEPT_NAME": "Bipolar disorder",
#' #       "STANDARD_CONCEPT": "S",
#' #       "STANDARD_CONCEPT_CAPTION": "Standard",
#' #       "INVALID_REASON": "V",
#' #       "INVALID_REASON_CAPTION": "Valid",
#' #       "CONCEPT_CODE": "13746004",
#' #       "DOMAIN_ID": "Condition",
#' #       "VOCABULARY_ID": "SNOMED",
#' #       "CONCEPT_CLASS_ID": "Clinical Finding"
#' #     },
#' #     "isExcluded": false,
#' #     "includeDescendants": true,
#' #     "includeMapped": true
#' #   }
#' # ]
#' # }
#' @export
get_atlas_concept <- function(id) {
  url <- paste0("https://atlas-demo.ohdsi.org/WebAPI/vocabulary/concept/", id)
  result <- httr::GET(url)
  if (httr::http_type(result) != "application/json") {
    stop("Atlas WebAPI did not return json", call. = FALSE)
  } else if (httr::status_code(result) == 500) {
    stop("Atlas WebAPI is unavailable")
  }
  concept_set <- httr::content(result, type = "application/json")
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

#' Get the Concept Set with related Concept IDs details
#'
#' Getting all the relevant concept IDs related to each condition.
#' Takes a json filename corresponding to the condition and returns the condition concept set
#'
#' @param filename JSON filename corresponding to the condition
#' (i.e bipolar disorder, depression, suicidality)
#'
#' @return DataFrame with descriptions of the related concept IDs
#' @export
#'
#' @examples ## Retrieving the dataframe of related concepts associated with bipolar disorder
#' \dontrun{
#' filename <- "data/exp_raw/concept_sets/bipolar_concept.json"
#' get_atlas_concept_set(filename)
#'
#' # | CONCEPT_ID | CONCEPT_NAME         | ... | VOCABULARY_ID    | CONCEPT_CLASS_ID  |
#' # | ---------- | -------------------- | --- | ---------------- | ----------------- |
#' # | 432876     | Bipolar I disorder   | ... | SNOMED           | Clinical Finding  |
#' # | 3220652    | Bipolar 1 disorder   | ... | Nebraska Lexicon | Clinical Finding  |
#'}
get_atlas_concept_set <- function(filename) {
  json_file <- rjson::fromJSON(file = filename)
  concept_set_url <- "https://atlas-demo.ohdsi.org/WebAPI/vocabulary/resolveConceptSetExpression/"
  cohort <- httr::POST(concept_set_url, body = json_file, encode = "json")
  if (cohort$status_code != 200) {
    stop("Atlas WebAPI unavailable or invalid JSON input")
  }
  cohort_list <- list()
  for (i in 1:length(httr::content(cohort, type = "application/json"))) {
    concept_id <- httr::content(cohort, type = "application/json")[i]
    url <- paste0("https://atlas-demo.ohdsi.org/WebAPI/vocabulary/concept/", concept_id)
    result <- httr::GET(url)
    df <- data.frame(httr::content(result, type = "application/json"))
    cohort_list[[i]] <- df
  }
  concept_set_df <- do.call(rbind, cohort_list)
  return(concept_set_df)
}
