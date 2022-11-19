care_sites_sql <- render('
SELECT 
     foo.care_site_id,
     care_site.place_of_service_concept_id,
     COUNT(foo.care_site_id) AS "counts"
FROM 
        (
		SELECT DISTINCT
			person_id, care_site_id
		FROM 
                        @schema.visit_occurrence
	) foo
FULL OUTER JOIN 
	@schema.care_site
ON 
	foo.care_site_id = care_site.care_site_id
GROUP BY 
	foo.care_site_id,
	care_site.place_of_service_concept_id;', schema = schema)
care_sites_sql <- translate(sql = care_sites_sql, targetDialect = dbms)

care_sites <- querySql(connection, care_sites_sql)
