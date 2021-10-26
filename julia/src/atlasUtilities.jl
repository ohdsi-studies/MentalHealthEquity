"""

get_atlas_concept(
    id::Int;
    isExcluded::Bool = false,
    includeDescendants::Bool = true,
    includeMapped::Bool = true
)

Takes a valid OMOP Concept ID and returns vocabulary concept data.

# Arguments

- `id::Int` - valid OMOP Concept ID
- `isExcluded::Bool` - Exclude this concept (and any of its descendants if selected) from the concept set
- `includeDescendants::Bool` - Consider not only this concept, but also all of its descendants
- `includeMapped::Bool` - Allow to search for non-standard concepts

# Returns

- `obj::JSON3.Object` - results in a JSON3 object representing the ATLAS concept

"""
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

function get_atlas_concept(
    id::Int;
    isExcluded::Bool = false,
    includeDescendants::Bool = true,
    includeMapped::Bool = true,
)
    get_atlas_concept(string(id); isExcluded, includeDescendants, includeMapped)
end


"""

	get_atlas_concept_set(contents::String)

Gets a list of concepts for a given concept set definition.

# Arguments

- `contents::String` - a string representation of the concept set query. **Should be a raw string of JSON input and not a JSON object.**

# Returns

- `list::Int` - list of OMOP Concept ids

"""
function get_atlas_concept_set(contents::String)
    path = "https://atlas-demo.ohdsi.org/WebAPI/vocabulary/resolveConceptSetExpression/"
    obj = HTTP.post(path, ["Content-Type" => "application/json"], contents)
    return parse.(Int, split(chop(String(obj.body); head = 1, tail = 1), ","))
end

export get_atlas_concept, get_atlas_concept_set
