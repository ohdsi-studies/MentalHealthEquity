# MentalHealthEquity Change Log

All notable changes to this project will be documented in this file.
 
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [0.1.0] - February 28th, 2023 

New minor release for package to execute baseline characterizations 

### Added  

- Characterization script added
- Instructions for characterization script
- Queries to run for characterization
- `renv` environment management
- `Rprofile` for RStudio work

### Changed 

- Directory for data now includes a `baseline` folder 
- `study` now includes in progress `test` scripts 

### Fixed 

- Numerous issues opened by @kzollove (thank you!)

## [0.0.2] - January 23rd, 2023

Patch release of MentalHealthEquity package for small updates and compliance

### Added 

Nothing

### Changed

- Made paths in the feasibility assessment test suite more precise
- Updated README to match OHDSI Studies template
- Removed patient level estimation/prediction tag from README 

### Fixed 

Nothing

## [0.0.1] - November 19th, 2022
 
First version release of the MentalHealthEquity package!
 
### Added

- Feasibility assessment
- Instructions for feasibility assessment
- Tests for feasibility assessment 
- Queries to run for feasibility assessment
- `renv` environment management
- `Rprofile` for RStudio work
 
### Changed

- Study overall structure
	- Folders for:
		- Research 
		- Scripts
		- Characterization instructions
- Deployment steps
 
### Fixed

- Out of memory issues due to inefficient feasibility queries
