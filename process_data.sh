echo -e "PMID\tYear\tTitle" > data/raw/processed_data.tsv

for file in ~/AHDS_project/data/raw/article-*.xml; do
    pmid=$(xmlstarlet sel -t -v "//PMID" "$file" | head -n 1)  # 提取 PMID
    year=$(xmlstarlet sel -t -v "//PubDate/Year" "$file" | head -n 1)  # 提取年份
    title=$(xmlstarlet sel -t -v "//ArticleTitle" "$file" | head -n 1)  # 提取标题

    if [ -n "$pmid" ] && [ -n "$year" ] && [ -n "$title" ]; then
        echo -e "${pmid}\t${year}\t${title}" >> data/raw/processed_data.tsv
    fi
done
