using HTTP
using JSON3

#= 

get_concept

Takes a valid OMOP Concept ID and returns a list of concept fields
  @param id Integer representing an OMOP Concept ID
 
  @return list Fields related to the concept 
 
  @examples
  get_concept(436665)
 
 @export 

=#
function get_concept(id::Int)
	get_concept(string(id))
end

function get_concept(id::String)
	path = "http://atlas-demo.ohdsi.org/WebAPI/vocabulary/concept/" * id
	HTTP.get(path) |> String |> JSON3.read
end


#=

get_cohort

=#
function get_cohort(condition_file::String)
	file_contents = read(condition_file, String) |> JSON3.read
	path = "http://atlas-demo.ohdsi.org/WebAPI/vocabulary/resolveConceptSetExpression/"
	HTTP.post(url = path, body = file_contents)
end
