dir.create("~/AHDS_project/data/clean", showWarnings = FALSE)

library(tidyverse)
library(tidytext)
library(SnowballC)

df <- read_tsv("data/raw/processed_data.tsv", col_names = c("PMID", "year", "title"), show_col_types = FALSE)

df <- df %>%
  filter(!is.na(title)) %>%
  unnest_tokens(word, title) %>%
  anti_join(stop_words, by="word") %>%
  filter(!str_detect(word, "\\d")) %>%
  mutate(word = wordStem(word))

write_tsv(df,"data/clean/cleaned_words.tsv")
