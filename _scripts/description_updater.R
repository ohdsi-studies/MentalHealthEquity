library(usethis)

usethis.description <- list(
        `Authors@R` = 'person("Jacob", "Zelko", email = "jacobszelko@gmail.com",
                              role = c("aut", "cre"),
                              comment = c(ORCID = "0000-0003-4531-1614"))',
        License = "MIT file LICENSE",
        Language = "en",
	Package = "MentalHealthEquity",
	Title = "Assessing Health Equity in Mental Healthcare Delivery Using a Federated Network Research Model",
	Version = "0.0.2",
	Description = "This is a network research package which assesses health disparities in populations with chronic mental illness. There are two components in this package: a feasibility component (to assess site feasibility) and a study component (to generate statistics of interest at each site)."
)

usethis::use_description(check_name = FALSE, roxygen = FALSE, fields = usethis.description)
