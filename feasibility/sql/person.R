person_sql <- render(
'SELECT DISTINCT "PERSON_1"."person_id"
FROM @schema."person" AS "PERSON_1";',
schema = schema)
person_sql <- translate(sql = person_sql, targetDialect = dbms)

person_ids <- querySql(connection, person_sql)
person_ids <- person_ids$PERSON_ID
