for pmid in $(grep -o '<Id>[^<]*' data/pmids.xml | sed 's/<Id>\([^<]*\)/\1/'); do

    curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=${pmid}" > data/article-${pmid}.xml
    sleep 1
done
