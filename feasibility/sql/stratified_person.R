db_year_range_sql <- render(
'SELECT
  MIN("observation_period_1"."observation_period_end_date") AS "first_year",
  MAX("observation_period_1"."observation_period_end_date") AS "last_year"
FROM @schema."observation_period" AS "observation_period_1";',
schema = schema)
db_year_range_sql <- translate(sql = db_year_range_sql, targetDialect = dbms)

db_year_range <- querySql(connection, db_year_range_sql)

# Determine earliest year data is recorded for
first_year <- db_year_range$FIRST_YEAR %>% 
	as.character %>%
	parse_datetime("%Y-%m-%d") %>%
	year

# Determine latest year data is recorded for
last_year <- db_year_range$LAST_YEAR %>% 
	as.character %>%
	parse_datetime("%Y-%m-%d") %>%
	year

person_stratified_sql <- render(
                             'SELECT
                             COUNT(DISTINCT ages.person_id) as counts,
                             ages.race_concept_id,
                             ages.gender_concept_id,
                             ages.age_group
                             FROM (SELECT
  "PERSON_2"."person_id",
  (CASE WHEN ("PERSON_2"."age" < 10) THEN \'0 - 9\' WHEN ("PERSON_2"."age" < 20) THEN \'10 - 19\' WHEN ("PERSON_2"."age" < 30) THEN \'20 - 29\' WHEN ("PERSON_2"."age" < 40) THEN \'30 - 39\' WHEN ("PERSON_2"."age" < 50) THEN \'40 - 49\' WHEN ("PERSON_2"."age" < 60) THEN \'50 - 59\' WHEN ("PERSON_2"."age" < 70) THEN \'60 - 69\' WHEN ("PERSON_2"."age" < 80) THEN \'70 - 79\' WHEN ("PERSON_2"."age" < 90) THEN \'80 - 89\' END) AS "age_group",
  "PERSON_2"."race_concept_id",
  "PERSON_2"."gender_concept_id"
FROM (SELECT
    "PERSON_1"."person_id",
    (@subtrahend - "PERSON_1"."year_of_birth") AS "age",
    "PERSON_1"."race_concept_id" AS "race_concept_id",
    "PERSON_1"."gender_concept_id" AS "gender_concept_id"
  FROM @schema.person AS "PERSON_1") AS "PERSON_2") ages
GROUP BY ages.age_group,ages.race_concept_id, ages.gender_concept_id;', schema = schema, subtrahend = last_year)

person_stratified_sql <- translate(sql = person_stratified_sql, targetDialect = dbms)
 
person_stratified <- querySql(connection, person_stratified_sql)
