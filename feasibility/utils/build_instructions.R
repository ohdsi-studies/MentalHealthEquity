library(rmarkdown)

rmarkdown::render(input = "set_up_instructions.Rmd", output_format = "pdf_document", output_file = "set_up_instructions.pdf")

rmarkdown::render(input = "feasibility_test.Rmd", output_format = "pdf_document", output_file = "feasibility_test.pdf")
