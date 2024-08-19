#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=coverage
#SBATCH --ntasks=1
#BATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=5G
#SBATCH --output=/project/anderson/%j.out
