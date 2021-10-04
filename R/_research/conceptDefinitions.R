library("httr")
library("rjson")

###########################
# TODO's for a First Pass #
###########################
#
# 1. Look up vocabulary concept codes 
# 
# EXAMPLE:
#    url <- "http://atlas-demo.ohdsi.org/WebAPI/vocabulary/concept/4273391/"
#    result <- GET(url)
#
# 2. Build JSON definitions for conditions
#
# EXAMPLE: See the JSON as an example:
#
# {
#   "items": [
#     {
#       "concept": {
# 	"CONCEPT_CLASS_ID": "Clinical Finding",
# 	"CONCEPT_CODE": "13746004",
# 	"CONCEPT_ID": 436665,
# 	"CONCEPT_NAME": "Bipolar disorder",
# 	"DOMAIN_ID": "Condition",
# 	"INVALID_REASON": "V",
# 	"INVALID_REASON_CAPTION": "Valid",
# 	"STANDARD_CONCEPT": "S",
# 	"STANDARD_CONCEPT_CAPTION": "Standard",
# 	"VOCABULARY_ID": "SNOMED"
#       },
#       "isExcluded": false,
#       "includeDescendants": true,
#       "includeMapped": true
#     }
#   ]
# }
#
# 3. Build tables detailing concept set as a CSV
#
# EXAMPLE:
#
# | Id       | Code    | Name             | Class        | Standard Concept  Caption | RC | DRC | Domain    | Vocabulary |
# |----------|---------|------------------|--------------|---------------------------|----|-----|-----------|------------|
# | 45618865 | D001714 | Bipolar Disorder | Main Heading | Non-Standard              | 0  | 0   | Condition | MeSH       |
#
# See link for how to get this information: http://webapidoc.ohdsi.org/index.html#-504206733
# And this can be an example of how you get concept information:
#
# url <- "http://atlas-demo.ohdsi.org/WebAPI/vocabulary/concept/4273391/"
# result <- GET(url)

# TODO: Get the descendants and mapped table codes for these concepts
bipolar_code <- 436665
depression_code <- 440383
suicidality_code <- 4273391

# Using JSON and sending it as an expression
# See: http://webapidoc.ohdsi.org/index.html#-896907989
bipolar_cohort <- fromJSON(file = "data/exp_raw/concept_sets/bipolar_disorder_atlas_concept_set.json")
url <- "http://atlas-demo.ohdsi.org/WebAPI/vocabulary/resolveConceptSetExpression/"
result <- POST(url, body = bipolar_cohort, encode = "json")

# This gets you the information about a specific concept
# See: http://webapidoc.ohdsi.org/index.html#-504206733 
url <- "http://atlas-demo.ohdsi.org/WebAPI/vocabulary/concept/4273391/"
result <- GET(url)
