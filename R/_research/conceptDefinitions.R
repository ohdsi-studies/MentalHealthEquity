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
bipolar_id <- 436665
depression_id<- 440383
suicidality_id <- 4273391

# Using JSON and sending it as an expression
# See: http://webapidoc.ohdsi.org/index.html#-896907989
bipolar_cohort <- fromJSON(file = "data/exp_raw/concept_sets/bipolar_disorder_atlas_concept_set.json")

url <- "http://atlas-demo.ohdsi.org/WebAPI/vocabulary/resolveConceptSetExpression/"
result <- POST(url, body = bipolar_cohort, encode = "json")

# This gets you the information about a specific concept
# See: http://webapidoc.ohdsi.org/index.html#-504206733
url <- "http://atlas-demo.ohdsi.org/WebAPI/vocabulary/concept/440383/"
result <- GET(url)



## This function takes in the concept ID for depression, bipolar, or suicidality and returns a list of the different concept set fields

get_concept <- function(id){
    url = paste0('http://atlas-demo.ohdsi.org/WebAPI/vocabulary/concept/', id)
    result <- GET(url)
    return(httr::content(result, "parsed"))
    }

## This function takes in the concept set, and it returns the JSON file with the proper querying format
## the proper format is given above but also in the bipolar_disorder_concept_set.json

get_json <- function(concept_set){
    jsontext <- jsonlite::toJSON(
        list(
            items = list(
                list(
                    concept = concept_set,
                    isExcluded = 'false',
                    includeDescendants = 'true',
                    includeMapped = 'true')
            )
        ),
        pretty = T, auto_unbox = T)
    return(jsontext)
}

## This function is similar to the get_json function, except this function will save it as a json file

write_json_file <- function(concept_set){
    if (concept_set$CONCEPT_ID == 436665){
        condition = 'bipolar_disorder'
    } else if (concept_set$CONCEPT_ID == 440383){
        condition == 'depression'
    } else if (concept_set$CONCEPT_ID == 4273391){
        condition = 'suicidality'
    }
    jsontext <- jsonlite::toJSON(
        list(
            items = list(
                list(
                    concept = concept_set,
                    isExcluded = 'false',
                    includeDescendants = 'true',
                    includeMapped = 'true')
            )
        ),
        pretty = T, auto_unbox = T)
    filename = paste0(condition, '_concept_set.json')
    path = '../MentalHealthEquity/R/data/exp_raw/concept_sets/'
    return(
        write(jsontext, paste0(path, filename)))
}


#### Getting the concept sets using concept ID ####
bipolar_id <- 436665
depression_id<- 440383
suicidality_id <- 4273391

bipolar_concept <- get_concept(bipolar_id);
depression_concept <- get_concept(depression_id)
suicidality_concept <- get_concept(suicidality_id);

#### Getting JSON (optional since we can use the file) ####
## If we just need the json text instead of using the file: use this function
bipolar_json <- get_json(bipolar_concept)
depression_json <- get_json(depression_concept)
suicide_json <- get_json(suicidality_concept)

#### Saving the json to a file ####
## Writing all concept sets as json files and saving it under the concept_sets folder
write_json_file(bipolar_concept)
write_json_file(depression_concept)
write_json_file(suicidality_concept)







### Extra notes and random code chunks ###

# for (i in 1:length(cd_suic)){
#     print(cd_suic[[i]][1])
# }

# write(jsonlite::toJSON(data, pretty = T, auto_unbox = T), file = "../MentalHealthEquity/R/data/exp_raw/concept_sets/test.json")

# idk why it's not working for me, but the path below works
# ../MentalHealthEquity/R/data/exp_raw/concept_sets/bipolar_disorder_atlas_concept_set.json'
