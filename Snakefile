rule download_data:
    output: directory("data/raw")
    log:"logs/download.log" 2
    shell:"""
        mkdir -p logs
        bash download_data.sh > {log}/download.log"""
rule process_data:
    input: "data/raw/article-*.xml"
    output: "data/raw/processed_data.tsv"
    shell:"""
        bash process_data.sh > logs/process.log"""
rule cleaned_words:
    input: "data/raw/processed_data.tsv"
    output: "data/clean/cleaned_words.tsv"
    shell:"""
        Rscript cleaned_words.R > logs/clean.log"""
rule visualisation:
    input: "data/clean/cleaned_words.tsv"
    output:"keyword_trend_plot.png"
    shell:"""
        Rscript visualisation.R > logs/visualisation.log"""


