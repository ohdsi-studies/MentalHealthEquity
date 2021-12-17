using DrWatson
@quickactivate "MentalHealthEquity"

using CSV
using DataFrames
using HTTP
using JSON3
using MentalHealthEquity

conditions =
    Dict("bipolar_disorder" => 436665, "depression" => 440383, "suicidality" => 4273391)

for condition in keys(conditions)
    json = get_atlas_concept(conditions[condition])
    file = open(datadir("exp_raw", "queries", "$(condition)_concept.json"), "w")
    JSON3.pretty(file, json)
    close(file)
end

for condition in keys(conditions)
    contents = read(datadir("exp_raw", "queries", "$(condition)_concept.json"), String)
    concept_list =
        get_atlas_concept_set(contents)
    df = DataFrame()
    for concept_id in concept_list
        concept = get_atlas_concept(concept_id) |> JSON3.read
        push!(df, concept[:items][1][:concept], cols = :union)
    end
    CSV.write(
        datadir("exp_raw", "concept_sets", "$(condition)_concept_set.csv"),
        df;
    )
end
