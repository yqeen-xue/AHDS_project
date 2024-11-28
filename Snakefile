rule all:
    input:
        "logs/download.log",
        "logs/process.log",
        "logs/clean.log",
        "logs/visualisation.log"

rule download_data:
    output: "data/raw/article-*.xml"
    shell:"""
        bash download_data.sh > logs/download.log"""

rule process_data:
    input: "data/raw/article-*.xml"
    output: "data/processed_data.tsv"
    shell:"""
        bash process_data.sh > logs/process.log"""

rule text_processing:
    input: "data/processed_data.tsv"
    output: "data/cleaned_words.tsv"
    shell:"""
        Rscript text_processing.R > logs/clean.log"""

rule visualisation:
    input: "data/cleaned_words.tsv"
    shell:"""
        Rscript visualisation.R > logs/visualisation.log"""


