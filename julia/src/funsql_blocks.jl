function get_deduplicated_columns(q, primary, tables)
	initial_columns = Get.(primary.columns)
	columns = []
	for tab in tables
		push!(columns, Get.(filter(x -> !in(x, primary.columns), tab.columns), over = Get[tab.name])...)
	end
	final_query = q |> Select(vcat(initial_columns..., columns)...) 
	return final_query
end

export get_deduplicated_columns
