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


cd "${SLURM_SUBMIT_DIR}"

# Conda environment
source ~/.initMamba.sh
mamba activate AHDS

# Setup directories
mkdir -p logs
mkdir -p data/clean
mkdir -p data/raw

snakemake -c1
