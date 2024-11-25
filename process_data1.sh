for file in data/article-*.xml; do
    pmid=$(grep -o '<PMID>[^<]*' "$file" | sed 's/<PMID>\(.*\)<\/PMID>/\1/')
    year=$(grep -oP '<PubDate>\s*[^<]*' "$file" | head -n 1 | sed 's/<PubDate>\s*\([^<]*\)/\1/' | cut -d' ' -f1)
    title=$(grep -o '<ArticleTitle>[^<]*' "$file" | sed 's/<ArticleTitle>\(.*\)<\/ArticleTitle>/\1/')
    
    echo -e "${pmid}\t${year}\t${title}" >> data/processed_data.tsv
done