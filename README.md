
# AHDS Project Documentation

This document outlines the steps to set up, run, and troubleshoot the AHDS Project pipeline. The pipeline uses Conda environments, Snakemake, and SLURM for job management.

## Configuration

### Setting Up the Environment

Before running the scripts, ensure that the Conda environment is correctly set up.

1. Create the environment from the provided YAML file:
   ```bash
   conda env create -f environment.yaml
   ```
2. Activate the environment:
   ```bash
   conda activate AHDS-project
   ```
3. Check the available environments if activation fails:
   ```bash
   conda env list
   ```

## Running the Program

The workflow is managed by Snakemake, with jobs submitted via SLURM on HPC.

### Cloning the Repository

To clone the repository:
```bash
git clone git@github.com:user-name/AHDS_project.git
```

Navigate to the project folder:
```bash
cd AHDS_project
```

### Submitting Jobs on HPC

To submit the Snakemake pipeline as a batch job:
```bash
sbatch run_analysis.sh
```

To check the job status:
```bash
sacct -j [JOB_ID] -X
scontrol show job [JOB_ID]
```

To debug, view the SLURM output log:
```bash
cat slurm-[JOB_ID].out
```

## Workflow Steps

The pipeline consists of the following Snakemake rules:

###1. **Download Data**
   - **Purpose**: Downloads the raw data from a specified source.
   - Script: `download_data.sh`
   - Output: `data/raw/pmids.xml`, `logs/download.log`
   - Example command:
     ```bash
     bash download_data.sh > logs/download.log 2>&1
     ```

###2. **Process Data**
   - **Purpose**: Processes the raw data into a usable format.
   - Script: `process_data.sh`
   - Output: `data/raw/processed_data.tsv`, `logs/process.log`

###3. **Clean Data**
   - **Purpose**: Cleans and tokenizes the processed data, removing stopwords and performing word stemming.
   - Script: `cleaned_words.R`
   - Output: `data/clean/cleaned_words.tsv`, `logs/clean.log`

###4. **Visualization**
   - **Purpose**: Visualizes the cleaned data, generating plots and summaries.
   - Script: `visualisation.R`
   - Output: Graphical files saved in the `results/` folder.

## Troubleshooting

### Common Errors and Fixes

#### Error: "Missing Output Files"

If the pipeline reports missing output files, ensure that:
- All input files are correctly located.
- No prior errors occurred in earlier steps of the pipeline.

#### Error: "Environment Activation Failed"

If activating the Conda environment fails:
1. Check the environment exists:
   ```bash
   conda env list
   ```
2. Recreate the environment:
   ```bash
   conda env create -f environment.yaml
   ```

#### Error: SLURM Job Failed

1. Debug using SLURM output logs:
   ```bash
   cat slurm-[JOB_ID].out
   ```
2. Remove intermediate and output files to re-run the pipeline:
   ```bash
   rm -r data logs slurm_logs
   ```

## File Structure

The repository is organized as follows:

```
AHDS_project/
├── data/
│   ├── raw/
│   ├── clean/
├── logs/
├── slurm_logs/
├── download_data.sh
├── process_data.sh
├── cleaned_words.R
├── visualisation.R
├── environment.yaml
├── Snakefile
├── README.md
```

## Additional Notes

### Pushing Updates to Git

To push changes to the repository:
```bash
git add .
git commit -m "Descriptive commit message"
git push
```

### Reproducing the Environment

If transferring or reproducing the environment on another system:
```bash
conda env create -f environment.yaml
```
