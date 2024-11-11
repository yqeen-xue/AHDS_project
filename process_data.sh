for file in data/article-*.xml;do
pmid=$(grep -oP '(?<=<PMID>)[^<]+' "$file")
year=$(grep -oP '(?<=<PubDate>)[^<]+' "$file" | head -n 1)
title=$(grep -oP '(?<=<ArticleTitle>)[^<]+' "$file" | sed 's/<[^>]*>//g')
echo -e "${pmid}\t${year}\t${title}" >> data/processed_data.tsv
done

