library(testthat)

##############################################################
# Loading test libraries
##############################################################

library(DatabaseConnector)
library(Eunomia)
library(lubridate)
library(readr)
library(SqlRender)

##############################################################
# Test variables for Eunomia Connection
##############################################################

cat("Testing Eunomia Connection Test Suite\n")

eunomia_details <- Eunomia::getEunomiaConnectionDetails(databaseFile = "tests/eunomia.sqlite")

test_that("Eunomia Connection", {
        expect_equal(object = length(eunomia_details), expected = 9)
        expect_no_error(DatabaseConnector::connect(eunomia_details))
})

##############################################################
# Test variables for queries
##############################################################

cat("\nTesting SqlRender Query Rendering Test Suite\n")

rendered_query <- 'SELECT DISTINCT \"PERSON_1\".\"person_id\" FROM main.\"PERSON\" AS \"PERSON_1\"'

test_that("Rendering queries", {
        expect_equal(object = render('SELECT DISTINCT \"PERSON_1\".\"person_id\" FROM @schema.\"PERSON\" AS \"PERSON_1\"', schema = "main"), expected = rendered_query)
})

##############################################################
# Test variables for Eunomia Connection
##############################################################

cat("\nTesting Eunomia Queries and Results\n")

# Creating connection to Eunomia
connection <- DatabaseConnector::connect(eunomia_details)

query <- render('SELECT DISTINCT \"PERSON_1\".\"person_id\" FROM @schema.\"PERSON\" AS \"PERSON_1\" LIMIT 1', schema = "main")

test_that("Running query", {
        expect_equal(object = querySql(connection, query)$PERSON_ID, expected = 6)
})


##############################################################
# Testing feasibility assessment queries
##############################################################

connection <- DatabaseConnector::connect(eunomia_details)

schema <- "main"
dbms <- "sqlite"

source("../sql/stratified_person.R")
source("../sql/visit_type.R")

test_that("Running query", {
        expect_equal(object = querySql(conn, query)$PERSON_ID, expected = 6)
        expect_equal(object = person_stratified, expected = data.frame(read_csv("ref_stratified_person.csv")))
        expect_equal(object = data.frame(visit_types), expected = data.frame(read_csv("ref_visit_type.csv")))
})
