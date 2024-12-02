log_file <- "logs/clean.log"
dir.create(dirname(log_file), showWarnings = FALSE, recursive = TRUE)

log_connection <- file(log_file, open = "wt") 
writeLines("Starting cleaned_words.R\n", log_connection)
close(log_connection)

write_log <- function(message) {
  log_connection <- file(log_file, open = "at") 
  writeLines(message, log_connection)
  close(log_connection)
}

options(repos = c(CRAN = "https://cloud.r-project.org"))

required_packages <- c("tidyverse", "tidytext", "SnowballC")
for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    write_log(paste("Installing package:", pkg, "\n"))
    install.packages(pkg)
  }
}

library(tidyverse)
library(tidytext)
library(SnowballC)
write_log("Libraries loaded successfully\n")

input_file <- "data/raw/processed_data.tsv"
output_file <- "data/clean/cleaned_words.tsv"

if (!file.exists(input_file)) {
  write_log(paste("Error: Input file", input_file, "not found!\n"))
  stop("Input file not found!")
}

write_log(paste("Reading input file:", input_file, "\n"))

df <- read_tsv(input_file, col_names = c("PMID", "year", "title"), show_col_types = FALSE)

write_log("Processing data...\n")
df <- df %>%
  filter(!is.na(title)) %>%
  unnest_tokens(word, title) %>%
  anti_join(stop_words, by = "word") %>%
  filter(!str_detect(word, "\\d")) %>%
  mutate(word = wordStem(word))

write_log("Data processed successfully\n")

write_log(paste("Writing output file:", output_file, "\n"))
dir.create(dirname(output_file), showWarnings = FALSE, recursive = TRUE)
write_tsv(df, output_file)

write_log("Output file written successfully\n")
write_log("cleaned_words.R completed successfully\n")