# 创建日志文件夹和文件
log_file <- "logs/visualisation.log"
dir.create(dirname(log_file), showWarnings = FALSE, recursive = TRUE)

# 初始化日志文件
log_connection <- file(log_file, open = "wt") # 以写入模式覆盖旧日志
writeLines("Starting visualisation.R\n", log_connection)
close(log_connection)

# 日志追加函数
write_log <- function(message) {
  log_connection <- file(log_file, open = "at") # 追加模式打开
  writeLines(message, log_connection)
  close(log_connection)
}

# 加载所需库
write_log("Loading libraries...\n")
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
library(tidyverse)
library(ggplot2)
write_log("Libraries loaded successfully\n")

# 定义输入和输出路径
input_file <- "data/clean/cleaned_words.tsv"
output_plot <- "plots/keyword_trends.png"

# 检查输入文件是否存在
if (!file.exists(input_file)) {
  write_log(paste("Error: Input file", input_file, "not found!\n"))
  stop("Input file not found!")
}

# 读取数据
write_log(paste("Reading input file:", input_file, "\n"))
df <- read_tsv(input_file, show_col_types = FALSE)

# 数据聚合与处理
write_log("Aggregating and processing data...\n")
df_summary <- df %>%
  count(year, word, name = "n") %>%
  group_by(year) %>%
  slice_max(n, n = 5)

write_log("Data processed successfully\n")

# 绘制图表
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

# 保存图表
write_log(paste("Saving plot to:", output_plot, "\n"))
dir.create(dirname(output_plot), showWarnings = FALSE, recursive = TRUE)
ggsave(output_plot, plot, width = 8, height = 6, dpi = 300)

write_log("visualisation.R completed successfully\n")