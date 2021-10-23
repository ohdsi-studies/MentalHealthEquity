#=

get_concept

Takes a valid OMOP Concept ID and returns a list of concept fields
  @param id Integer representing an OMOP Concept ID

  @return list Fields related to the concept

  @examples
  get_concept(436665)

 @export

=#
function get_atlas_concept(
    id::Int;
    isExcluded::Bool = false,
    includeDescendants::Bool = true,
    includeMapped::Bool = true,
)
    get_atlas_concept(string(id); isExcluded, includeDescendants, includeMapped)
end

function get_atlas_concept(
    id::String;
    isExcluded::Bool = false,
    includeDescendants::Bool = true,
    includeMapped::Bool = true,
)
    path = "https://atlas-demo.ohdsi.org/WebAPI/vocabulary/concept/" * id
    concept = HTTP.get(path) |> x -> String(x.body) |> JSON3.read
    obj = Dict(
        "items" => [
            Dict(
                "concept" => concept,
                "isExcluded" => isExcluded,
                "includeDescendants" => includeDescendants,
                "includeMapped" => includeMapped,
            ),
        ],
    )

    return JSON3.write(obj)

end


#=

get_cohort

=#
function get_atlas_concept_set(condition_file::String)
    file_contents = read(condition_file, String) 
    path = "https://atlas-demo.ohdsi.org/WebAPI/vocabulary/resolveConceptSetExpression/"
    obj = HTTP.post(path, ["Content-Type" => "application/json"], file_contents)
    return parse.(Int, split(chop(String(obj.body); head = 1, tail = 1), ","))
end

export get_atlas_concept, get_atlas_concept_set
