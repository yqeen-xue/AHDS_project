library(tidyverse)
library(tidytext)
library(SnowballC)
library(topicmodels)

df <- read_tsv("data/processed_data.tsv", col_names = c("PMID", "year", "title"), show_col_types = FALSE)

df <- df %>%
  filter(!is.na(title)) %>%
  unnest_tokens(word, title) %>%
  anti_join(stop_words) %>%
  filter(!str_detect(word, "\\d")) %>%
  mutate(word = wordStem(word))

write_tsv(df, "data/cleaned_words.tsv")


