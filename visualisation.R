library(tidyverse)
library(tidytext)

df <- read_tsv("data/clean/cleaned_words.tsv", show_col_types = FALSE)

df_summary <- df %>%
  mutate(year = as.numeric(year)) %>%  
  filter(!is.na(year) & year >= 2020 & year <= 2025) %>%  
  count(year, word, name = "n") %>%  
  group_by(year) %>%
  slice_max(n, n = 5)  


plot <- ggplot(df_summary, aes(x = year, y = n, color = word, group = word)) +
  geom_line() +
  labs(
    title = "Top Keywords Over Time in COVID-19 Research",
    x = "Year",
    y = "Frequency",
    color = "Keyword"
  ) +
  theme_minimal() +
  scale_x_continuous(
    limits = c(2020, 2025),  
    breaks = 2020:2025       
  )

if (!dir.exists("~/AHDS_project")) {
  dir.create("~/AHDS_project", recursive = TRUE)
}

print(plot)
ggsave("~/AHDS_project/keyword_trend_plot.png", plot = plot, width = 8, height = 6, dpi = 300)