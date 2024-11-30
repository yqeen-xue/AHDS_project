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
#SBATCH --error=./slurm_logs/%j.err

mkdir -p slurm_logs
mkdir -p logs
mkdir -p data/clean
mkdir -p data/raw

cd "${SLURM_SUBMIT_DIR}"

if [ -f /user/work/kq24393/miniforge3/etc/profile.d/conda.sh ]; then
  source /user/work/kq24393/miniforge3/etc/profile.d/conda.sh
else
  echo "Error: Conda initialization script not found at /user/work/kq24393/miniforge3/etc/profile.d/conda.sh" >&2
  exit 1
fi

conda activate base

if ! conda info --envs | grep -q "AHDS-project"; then
  if [ -f environment.yaml ]; then
    conda env create -f environment.yaml
  else
    echo "Error: environment.yaml not found. Cannot create Conda environment." >&2
    exit 1
  fi
fi

conda activate AHDS-project


snakemake -c1

