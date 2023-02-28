location_sql <- render('SELECT
  "LOCATION_2"."state",
  COUNT("LOCATION_2"."state") AS COUNT
FROM (
  SELECT
    "LOCATION_1"."location_id",
    "LOCATION_1"."state"
  FROM @schema.location AS "LOCATION_1"
) AS "LOCATION_2"
JOIN @schema.person AS "PERSON_1" ON ("LOCATION_2"."location_id" = "PERSON_1"."location_id")
GROUP BY "LOCATION_2".state;', schema = schema)
location_sql <- translate(sql = location_sql, targetDialect = dbms)

location <- querySql(connection, location_sql)
