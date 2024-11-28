cd ~/AHDS_project
mkdir -p logs
mkdir -p data/raw

LOGFILE="logs/download.log"
> $LOGFILE

echo "Downloading PMIDs..." >> $LOGFILE
curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=%22long%20covid%22&retmax=4" > data/raw/pmids.xml 2>> $LOGFILE

if [ $? -ne 0 ]; then
    echo "Failed to download PMIDs." >> $LOGFILE
    exit 1
fi
echo "PMIDs downloaded successfully." >> $LOGFILE

echo "Downloading articles..." >> $LOGFILE
for pmid in $(grep -o '<Id>[^<]*' data/raw/pmids.xml | sed 's/<Id>\([^<]*\)/\1/'); do
    echo "Downloading article for PMID: ${pmid}" >> $LOGFILE
    curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=${pmid}" > data/raw/article-${pmid}.xml 2>> $LOGFILE
    if [ $? -ne 0 ]; then
        echo "Failed to download article for PMID: ${pmid}" >> $LOGFILE
    else
        echo "Successfully downloaded article for PMID: ${pmid}" >> $LOGFILE
    fi
    sleep 1
done

echo "All downloads completed." >> $LOGFILE

curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=%22long%20covid%22&retmax=4" > data/raw/pmids.xml
for pmid in $(grep -o '<Id>[^<]*' data/raw/pmids.xml | sed 's/<Id>\([^<]*\)/\1/'); do
    curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=${pmid}" > data/raw/article-${pmid}.xml
    sleep 1
done
