library(httr)
library(jsonlite)

check_api <- function(resp) {
  if (httr::status_code(resp) == 500) {
    skip("API not available")
  } else if (httr::status_code(resp) == 412) {
    skip("Invalid JSON input")
  } else if (httr::http_type(resp) != "application/json") {
    skip("Invalid JSON input")
  }
}

test_that("Atlas API and Concept ID", {
  id <- 436665
  url <- paste0("https://atlas-demo.ohdsi.org/WebAPI/vocabulary/concept/", id)
  resp <- httr::GET(url)
  check_api(resp)
  expect_equal(
    get_atlas_concept(id),
    jsonlite::toJSON(
      list(
        items = list(
          list(
            concept = list(
              "CONCEPT_ID" = 436665,
              "CONCEPT_NAME" = "Bipolar disorder",
              "STANDARD_CONCEPT" = "S",
              "STANDARD_CONCEPT_CAPTION" = "Standard",
              "INVALID_REASON" = "V",
              "INVALID_REASON_CAPTION" = "Valid",
              "CONCEPT_CODE" = "13746004",
              "DOMAIN_ID" = "Condition",
              "VOCABULARY_ID" = "SNOMED",
              "CONCEPT_CLASS_ID" = "Clinical Finding"
            ),
            isExcluded = FALSE,
            includeDescendants = TRUE,
            includeMapped = TRUE
          )
        )
      ),
      pretty = T, auto_unbox = T
    )
  )
})
