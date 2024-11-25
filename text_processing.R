library(tidyverse)
library(tidytext)
library(SnowballC)

df <- read_tsv("data/processed_data.tsv",col_names = c("PMID","year","title"),show_col_types = FALSE)

df <- df %>%
  filter(!is.na(title)) %>%
  unnest_tokens(word, title) %>%
  anti_join(stop_words, by="word") %>%
  filter(!str_detect(word, "\\d")) %>%
  mutate(word = wordStem(word))

write_tsv(df,"data/cleaned_words.tsv")

df_summary <- df %>%
  count(year, word) %>%
  group_by(year) %>%
  top_n(10, n)

ggplot(df_summary, aes(x = as.integer(year), y = n, color = word)) +
  geom_line() +
  labs(title = "Top Keywords Over Time in COVID-19 Research",
       x = "Year", y = "Frequency") +
  theme_minimal()
ggsave("data/keyword_trend_plot.png", width = 8, height = 6)
