condition_filter <- function(schema, conditions, dbms, connection)  { 

sql <- render(
'SELECT DISTINCT "CONDITION_OCCURRENCE_1"."person_id"
FROM @schema."condition_occurrence" AS "CONDITION_OCCURRENCE_1"
WHERE ("CONDITION_OCCURRENCE_1"."condition_concept_id" IN (@conditions));', 
schema = schema, 
conditions = conditions)

sql <- translate(sql = sql, targetDialect = dbms)

patient_ids <- querySql(connection, sql)
patient_ids <- patient_ids$PERSON_ID

return (patient_ids)

}
