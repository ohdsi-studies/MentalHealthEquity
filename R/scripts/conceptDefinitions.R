# TODO: I cannot get the library to load properly and I still need to source the files to get proper functions needed in the renv environment
library("MentalHealthEquity")

source("R/atlasUtilities.R")

# Getting concept sets for condition using concept ID and writing to json file
bipolar_id <- 436665
depression_id <- 440383
suicidality_id <- 4273391

ids <- c(bipolar_id, depression_id, suicidality_id)
names <- c("bipolar", "depression", "suicidality")

base_filename <- "data/exp_raw/concept_sets/"

# Output condition concept set JSON file paths
condition_paths <- paste0(base_filename, names, "_concept.json")

# Write condition concept set JSON representation to files
condition_json <- lapply(ids, FUN = get_atlas_concept)
mapply(FUN = write, condition_json, condition_paths)

# Output condition concept set CSV file paths
concept_paths <- paste0(base_filename, names, "_concept_set.csv")
concept_sets <- lapply(condition_paths, FUN = get_atlas_concept_set)

# Write concepts from concept set to CSV
for (i in 1:length(concept_paths)) {
  write.csv(concept_sets[[i]], concept_paths[[i]])
}


