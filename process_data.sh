#!/bin/bash

# 创建必要的目录
mkdir -p ~/data/logs
mkdir -p ~/data/processed

# 日志文件路径
LOGFILE=~/data/logs/process.log

# 清空旧日志内容
> $LOGFILE

# 开始记录日志
echo "Starting data processing..." >> $LOGFILE

# 遍历输入文件并处理（假设文件路径匹配 ~/data/raw/article-*.xml）
for file in ~/data/raw/article-*.xml; do
    echo "Processing file: $file" >> $LOGFILE
    output_file=~/data/processed/$(basename "$file" .xml).tsv

    # 执行数据处理逻辑（例如调用 Python 脚本）
    python3 process_data.py "$file" "$output_file" >> $LOGFILE 2>&1

    # 检查处理状态并记录日志
    if [ $? -ne 0 ]; then
        echo "Processing failed for file: $file" >> $LOGFILE
    else
        echo "Successfully processed: $file" >> $LOGFILE
    fi
done

# 完成处理
echo "Data processing completed." >> $LOGFILE
echo -e "PMID\tYear\tTitle" > data/raw/processed_data.tsv

for file in ~/AHDS_project/data/raw/article-*.xml; do
    pmid=$(xmlstarlet sel -t -v "//PMID" "$file" | head -n 1)  # 提取 PMID
    year=$(xmlstarlet sel -t -v "//PubDate/Year" "$file" | head -n 1)  # 提取年份
    title=$(xmlstarlet sel -t -v "//ArticleTitle" "$file" | head -n 1)  # 提取标题

    if [ -n "$pmid" ] && [ -n "$year" ] && [ -n "$title" ]; then
        echo -e "${pmid}\t${year}\t${title}" >> data/raw/processed_data.tsv
    fi
done
