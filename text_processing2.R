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

write_tsv(df, "data/cleaned_words2.tsv")

df_dtm <- df %>%
  count(PMID, word, sort = TRUE) %>%
  cast_dtm(PMID, word, n)

k <- 5  
lda_model <- LDA(df_dtm, k = k, control = list(seed = 1234))

topics <- tidy(lda_model, matrix = "beta")

documents <- tidy(lda_model, matrix = "gamma")

top_terms <- topics %>%
  group_by(topic) %>%
  slice_max(beta, n = 10) %>%
  ungroup() %>%
  arrange(topic, -beta)

ggplot(top_terms, aes(x = reorder_within(term, beta, topic), y = beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip() +
  labs(title = "Top Terms in Each Topic",
       x = NULL, y = "Beta") +
  theme_minimal() +
  scale_x_reordered()

ggsave("data/lda_top_terms2.png", width = 8, height = 6)

df_year <- df %>%
  select(PMID, year) %>%
  distinct()

doc_topics <- documents %>%
  inner_join(df_year, by = c("document" = "PMID"))

topic_trends <- doc_topics %>%
  group_by(year, topic) %>%
  summarise(mean_gamma = mean(gamma)) %>%
  ungroup()

ggplot(topic_trends, aes(x = year, y = mean_gamma, color = factor(topic))) +
  geom_line(size = 1) +
  labs(title = "Topic Trends Over Time",
       x = "Year", y = "Mean Topic Probability",
       color = "Topic") +
  theme_minimal()

ggsave("data/lda_topic_trends2.png", width = 8, height = 6)
