visit_types_sql <- render('SELECT
	visit_concept_id, 
	COUNT(visit_concept_id) 
FROM (
	SELECT DISTINCT 
		person_id,
		visit_concept_id
	FROM
		@schema.visit_occurrence 
	) tmp
GROUP BY 
	visit_concept_id;', schema = schema)
visit_types_sql <- translate(sql = visit_types_sql, targetDialect = dbms)

visit_types <- querySql(connection, visit_types_sql)
