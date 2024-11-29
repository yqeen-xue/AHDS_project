#!/bin/bash

set -e

#SBATCH --job-name=test_job
#SBATCH --partition=teach_cpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=0:10:00
#SBATCH --mem=100M
#SBATCH --account=SSCM033324
#SBATCH --output ./slurm_logs/%j.out

mkdir -p slurm_logs
mkdir -p logs
mkdir -p data/clean
mkdir -p data/raw

cd "${SLURM_SUBMIT_DIR}"

# Conda environment
source ~/miniconda3/etc/profile.d/conda.sh
if ! conda info --envs | grep -q AHDS-project; then
  conda env create -f environment.yaml
fi
conda activate AHDS-project


snakemake -c1

