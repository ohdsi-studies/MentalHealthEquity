library(SqlRender)
library(DatabaseConnector)

#################################
# TODO's for a Filter Functions #
#################################

connectionDetails <- DatabaseConnector::createConnectionDetails(
   dbms = "postgresql",
   server = "data.hdap.gatech.edu/synpuf_v5",
   user = keyring::key_list("synPUF")[1,2],
   password = keyring::key_get("synPUF", keyring::key_list("synPUF")[1,2]),
   port = 5434,
   pathToDriver = "./utils"
)


# 1. Visit Filter
# VisitFilterPersonIDs():
#    SELECT DISTINCT "visit_occurrence_1"."person_id"
# FROM "synpuf5"."visit_occurrence" AS "visit_occurrence_1"
# WHERE ("visit_occurrence_1"."visit_concept_id" IN (1000, 2000))")

# @examples
# \dontrun{
VisitFilterPersonIDs(
    connectionDetails = connectionDetails,
    cdmDatabaseSchema = "synpuf5",
    table = "visit_occurrence",
    conceptIds = (9201)
)
# }

VisitFilterPersonIDs <- function(connectionDetails,
                                 cdmDatabaseSchema,
                                 table, conceptIds){
   conn <- DatabaseConnector::connect(connectionDetails)
   sql <- " SELECT DISTINCT visit_occurrence_1.person_id
            FROM @cdmDatabaseSchema.@table as visit_occurrence_1
            WHERE (visit_occurrence_1.visit_concept_id IN @conceptIds)
          "
   result <- DatabaseConnector::renderTranslateQuerySql(conn, sql,
                                                        cdmDatabaseSchema = cdmDatabaseSchema,
                                                        table = table,
                                                        conceptIds = conceptIds)
   disconnect(conn)
   return(result)
}


conn <- connect(connectionDetails)
sql <- " SELECT DISTINCT visit_occurrence_1.visit_concept_id
            FROM visit_occurrence as visit_occurrence_1
          "
DatabaseConnector::renderTranslateQuerySql(conn, sql)



# 2.
# ConditionFilterPersonIDs():
#    SELECT DISTINCT "condition_occurrence_1"."person_id"
# FROM "synpuf5"."condition_occurrence" AS "condition_occurrence_1" WHERE ("condition_occurrence_1"."condition_concept_id" IN (1000, 2000))"")

# 3.
# RaceFilterPersonIDs():
#    SELECT DISTINCT "person_1"."person_id"
# FROM "synpuf5"."person" AS "person_1"
# WHERE ("person_1"."race_concept_id" IN (1000, 2000))



# 4.
# GenderFilterPersonIDs():
# SELECT DISTINCT "person_1"."person_id"
# FROM "synpuf5"."person" AS "person_1"
# WHERE "person_1"."gender_concept_id" IN (1000, 2000)

# 5.
# StateFilterPersonIDs():
#    SELECT "join_1"."person_id"
# FROM (
# SELECT "location_2"."location_id"
# FROM (
# SELECT
# "location_1"."location_id",
# "location_1"."state"
# FROM "synpuf5"."location" AS "location_1"
# ) AS "location_2"
# WHERE ("location_2"."state" IN (1000, 2000)) ) AS "location_3"
# JOIN (
# SELECT
# "person_1"."person_id", "person_1"."location_id"
# FROM "synpuf5"."person" AS "person_1"
# ) AS "join_1" ON ("location_3"."location_id" = "join_1"."location_id")







