#!/bin/bash
mkdir -p ~/data/logs
mkdir -p ~/data/processed

LOGFILE=~/data/logs/process.log

> $LOGFILE

echo "Starting data processing..." >> $LOGFILE

for file in ~/data/raw/article-*.xml; do
    echo "Processing file: $file" >> $LOGFILE
    output_file=~/data/processed/$(basename "$file" .xml).tsv

    python3 process_data.py "$file" "$output_file" >> $LOGFILE 2>&1

    if [ $? -ne 0 ]; then
        echo "Processing failed for file: $file" >> $LOGFILE
    else
        echo "Successfully processed: $file" >> $LOGFILE
    fi
done

echo "Data processing completed." >> $LOGFILE
echo -e "PMID\tYear\tTitle" > data/raw/processed_data.tsv

for file in ~/AHDS_project/data/raw/article-*.xml; do
    pmid=$(xmlstarlet sel -t -v "//PMID" "$file" | head -n 1)  #PMID
    year=$(xmlstarlet sel -t -v "//PubDate/Year" "$file" | head -n 1)  #YEAR¹´ä»½
    title=$(xmlstarlet sel -t -v "//ArticleTitle" "$file" | head -n 1)  #TITLE

    if [ -n "$pmid" ] && [ -n "$year" ] && [ -n "$title" ]; then
        echo -e "${pmid}\t${year}\t${title}" >> data/raw/processed_data.tsv
    fi
done
