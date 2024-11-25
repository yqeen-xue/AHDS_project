rule download_data:
    output: "data/pmids.xml"
    shell:
        "bash download_data.sh"

rule process_data:
    input: "data/pmids.xml"
    output: "data/processed_data.tsv"
    shell:
        "bash process_data.sh"

rule text_processing:
    input: "data/processed_data.tsv"
    output: "data/cleaned_words.tsv"
    shell:
        "Rscript text_processing.R"


