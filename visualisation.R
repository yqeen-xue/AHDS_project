log_file <- "logs/visualisation.log"
dir.create(dirname(log_file), showWarnings = FALSE, recursive = TRUE)

log_connection <- file(log_file, open = "wt")
writeLines("Starting visualisation.R\n", log_connection)
close(log_connection)

write_log <- function(message) {
  log_connection <- file(log_file, open = "at") 
  writeLines(message, log_connection)
  close(log_connection)
}

write_log("Loading libraries...\n")
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
library(tidyverse)
library(ggplot2)
write_log("Libraries loaded successfully\n")

input_file <- "data/clean/cleaned_words.tsv"
output_plot <- "plots/keyword_trends.png"

if (!file.exists(input_file)) {
  write_log(paste("Error: Input file", input_file, "not found!\n"))
  stop("Input file not found!")
}

write_log(paste("Reading input file:", input_file, "\n"))
df <- read_tsv(input_file, show_col_types = FALSE)

write_log("Aggregating and processing data...\n")
df_summary <- df %>%
  count(year, word, name = "n") %>%
  group_by(year) %>%
  slice_max(n, n = 5)

write_log("Data processed successfully\n")

write_log("Creating plot...\n")
plot <- ggplot(data = df_summary, aes(x = as.numeric(year), y = n, color = word, group = word)) +
  geom_line() +
  labs(
    title = "Top Keywords Over Time",
    x = "Year",
    y = "Frequency",
    color = "Keyword"
  ) +
  theme_minimal()+
  scale_x_continuous(
    limits = c(2020, 2025),  
    breaks = 2020:2025       
  )

write_log(paste("Saving plot to:", output_plot, "\n"))
dir.create(dirname(output_plot), showWarnings = FALSE, recursive = TRUE)
ggsave(output_plot, plot, width = 8, height = 6, dpi = 300)

write_log("visualisation.R completed successfully\n")