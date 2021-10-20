library("MentalHealthEquity")

# source("atlasUtilities.R")
# source("writeUtilities.R")
# devtools::load_all()

#### Getting the concept sets using concept ID and writing to json file####
bipolar_id <- 436665
depression_id <- 440383
suicidality_id <- 4273391

ids <- c(bipolar_id, depression_id, suicidality_id)
names <- c("bipolar", "depression", "suicidality")

base_filename <- "../data/exp_raw/concept_sets/"
condition_paths <- paste0(base_filename, names, "_concept.json")

condition_json <- lapply(ids, FUN = get_concept_atlas)
mapply(FUN = write, condition_json, condition_paths)


# concept_sets should return a list of dataframes.
# Each dataframe corresponds to the condition (bipolar, depression, suicidality)
# mapply should be able to write each dataframe to its own separate path
# condition_paths is for the input json file name
# concept_paths is the output file name for the dataframe csv

concept_paths <- paste0(base_filename, names, "_concept_set.csv")
concept_sets <- lapply(condition_paths, FUN = get_concept_cohort)
for (i in 1:length(concept_paths)) {
  write.csv(concept_sets[[i]], concept_paths[[i]])
}
