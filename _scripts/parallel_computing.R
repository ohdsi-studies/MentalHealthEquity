library(doParallel)
library(foreach)
library(JuliaConnectoR)
library(parallel)

Sys.setenv("JULIA_NUM_THREADS" = parallel::detectCores(), "DATADEPS_ALWAYS_ACCEPT" = TRUE)

myCluster <- makeCluster(4, type = "FORK")
registerDoParallel(myCluster)

pkg <- juliaImport("Pkg")
pkg$activate("OHDSI", shared = TRUE) 
pkg$add(c("OMOPCDMCohortCreator", "HealthSampleData", "SQLite"))

indices <- c(1, 2, 3, 4, 5)
starts <- c(1, 1, 1, 1, 1)
ends <- c(4000, 4000, 4000, 4000, 4000)

values <- foreach(idx = indices) %dopar% { 

	pkg <- juliaImport("Pkg")
	pkg$activate("OHDSI", shared = TRUE) 

	hsd <- juliaImport("HealthSampleData")
	slt <- juliaImport("SQLite")
	occ <- juliaImport("OMOPCDMCohortCreator")

	eunomia <- hsd$Eunomia()
	conn <- slt$DB(eunomia)
	
	occ$GenerateDatabaseDetails(juliaEval(":sqlite"), "main")
	occ$GenerateTables(conn)

	data.frame(occ$GetPatientGender(starts[idx]:ends[idx], conn))
}

stopCluster(myCluster)
