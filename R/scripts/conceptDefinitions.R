library("MentalHealthEquity")

#source("atlasUtilities.R")
#source("writeUtilities.R")

#### Getting the concept sets using concept ID ####
bipolar_id <- 436665
depression_id <- 440383
suicidality_id <- 4273391

bipolar_concept <- get_concept(bipolar_id)
depression_concept <- get_concept(depression_id)
suicidality_concept <- get_concept(suicidality_id)
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

#### Getting the cohorts ####
bipolar_cohort <- get_cohort(bipolar_disorder)
depression_cohort <- get_cohort(depression)
suicidality_cohort <- get_cohort(suicidality)

#### Writing the cohorts to csv files ####
base_filename <- "../data/exp_raw/concept_sets/"

write.csv(get_concept_set(bipolar_cohort), file = paste0(base_filename, "bipolar_disorder_concept_set.csv"))
write.csv(get_concept_set(depression_cohort), file = paste0(base_filename, "depression_concept_set.csv"))
write.csv(get_concept_set(suicidality_cohort), file = paste0(base_filename, "suicidality_concept_set.csv"))
