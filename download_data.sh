

curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=%22long%20covid%22&retmax=10000" > data/raw/pmids.xml

for pmid in $(grep -o '<Id>[^<]*' data/pmids.xml | sed 's/<Id>\([^<]*\)/\1/'); do

    curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=${pmid}" > data/raw/article-${pmid}.xml
    sleep 1
done
