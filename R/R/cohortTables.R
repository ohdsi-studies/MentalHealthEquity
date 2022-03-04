#' Create cohort tables
#'
#' Generate cohort tables using the Atlas Web Api cohort id(s) and saving the cohort definition set to the to a JSON or SQL folder
#'
#' @param connectionDetails Connection details to the database server using createConnectionDetails() from the DatabaseConnector package
#' @param cohortIds List of cohort ids to be included in the cohort table
#' @param baseUrl The base URL for the Atlas Web Api. For example, "http://api.ohdsi.org:8080/WebAPI"
#' @param cdmDatabaseSchema Schema name for the OMOP CDM database
#' @param cohortDatabaseSchema Schema name for the cohort table
#' @param cohortTable Name for the cohort table, default is "cohort"
#' @param jsonFolder JSON folder location for the cohort definition set
#' @param sqlFolder SQL folder location for the cohort definition set
#' @param getCohortCounts When TRUE, it will return cohort counts from the cohort table just created
#'
#' @examples
#' \dontrun{
#' createCohorts(
#'     connectionDetails = Eunomia::getEunomiaConnectionDetails(),
#'     cohortIds = cohortIds,
#'     baseUrl = "http://api.ohdsi.org:8080/WebAPI",
#'     cdmDatabaseSchema = "main",
#'     cohortDatabaseSchema = "main",
#'     cohortTable = "example_cohort"
#' )
#' }
#'
#' @export

createCohorts <- function(connectionDetails,
                          cohortIds,
                          baseUrl,
                          cdmDatabaseSchema,
                          cohortDatabaseSchema,
                          cohortTable = "cohort",
                          jsonFolder = file.path("inst/cohorts"),
                          sqlFolder = file.path("inst/sql/sql_server"),
                          getCohortCounts = FALSE) {
    cohortDefinitionSet <- ROhdsiWebApi::exportCohortDefinitionSet(
        baseUrl = baseUrl,
        cohortIds = cohortIds
    )
    CohortGenerator::saveCohortDefinitionSet(
        cohortDefinitionSet = cohortDefinitionSet,
        jsonFolder = jsonFolder,
        sqlFolder = sqlFolder
    )
    cohortTableNames <- CohortGenerator::getCohortTableNames(cohortTable)
    CohortGenerator::createCohortTables(
        connectionDetails = connectionDetails,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTableNames = cohortTableNames
    )
    cohortsGenerated <- CohortGenerator::generateCohortSet(
        connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTableNames = cohortTableNames,
        cohortDefinitionSet = cohortDefinitionSet
    )
    if (getCohortCounts == TRUE) {
        cohortCounts <- CohortGenerator::getCohortCounts(
            connectionDetails = connectionDetails,
            cohortDatabaseSchema = cohortDatabaseSchema,
            cohortTable = cohortTable
        )
        return(cohortCounts)
    }
}

#' Cleaning up and Dropping Cohort Tables
#'
#' Removing the cohort and residual tables
#'
#' @param connectionDetails Connection details to the database server using createConnectionDetails() from the DatabaseConnector package
#' @param cohortDatabaseSchema Schema name for the cohort table
#' @param cohortTable Name for the cohort table, default is "cohort"
#'
#' @export


dropCohorts <- function(connectionDetails,
                        cohortDatabaseSchema,
                        cohortTable = "cohort") {
    cohortTableNames <- CohortGenerator::getCohortTableNames(cohortTable)
    CohortGenerator::dropCohortStatsTables(
        connectionDetails = connectionDetails,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTableNames = cohortTableNames
    )
    conn <- DatabaseConnector::connect(connectionDetails)
    sql <- "
  TRUNCATE TABLE @cohort_db_schema.@cohort_table;
  DROP TABLE @cohort_db_schema.@cohort_table;"
    DatabaseConnector::renderTranslateExecuteSql(conn, sql,
        cohort_db_schema = cohortDatabaseSchema,
        cohort_table = cohortTable
    )
    DatabaseConnector::disconnect(conn)
}

