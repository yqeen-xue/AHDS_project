rule all:
    input:
        "data/raw/processed_data.tsv", 
        "logs/download.log",
        "logs/process.log",
        "logs/clean.log",
        "logs/visualisation.log"
rule download_data:
    output:
        "data/raw/pmids.xml",
        "logs/download.log"
    shell:
        """
        mkdir -p logs
        bash download_data.sh > logs/download.log 2>&1
        """
rule process_data:
    input:
        "data/raw/pmids.xml"
    output:
        "data/raw/processed_data.tsv",
        "logs/process.log"
    shell:
        """
        mkdir -p logs
        bash process_data.sh > logs/process.log 2>&1
        """
rule cleaned_words:
    input:
        "data/raw/processed_data.tsv"
    output:
        "data/clean/cleaned_words.tsv",
        "logs/clean.log"
    shell:
        """
        mkdir -p logs
        Rscript cleaned_words.R > logs/clean.log 2>&1
        """
rule visualisation:
    input:
        "data/clean/cleaned_words.tsv"
    output:
        "plots/keyword_trends.png",
        "logs/visualisation.log"
    shell:
        """
        mkdir -p logs
        mkdir -p plots
        Rscript visualisation.R > logs/visualisation.log 2>&1
        """



