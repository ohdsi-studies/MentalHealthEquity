library(httr)
library(rjson)
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

test_that("Atlas API and Concept Set", {
  filename <- tempfile("suicidality", fileext = ".json")
  write(get_atlas_concept(4273391), file = filename)
  expect_true(file.exists(filename))
  json_file <- rjson::fromJSON(file = filename)
  concept_set_url <- "https://atlas-demo.ohdsi.org/WebAPI/vocabulary/resolveConceptSetExpression/"
  cohort <- httr::POST(concept_set_url, body = json_file, encode = "json")
  check_api(cohort)
  expect_equal(class(get_atlas_concept_set(filename)), "data.frame")
  expect_equal(length(get_atlas_concept_set(filename)$CONCEPT_ID), 35)
})

