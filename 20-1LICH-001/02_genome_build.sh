#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=bowtie_alignment
#SBATCH --ntasks=1
#BATCH --cpus-per-task=8
#SBATCH --time=72:00:00
#SBATCH --mem=120G
#SBATCH --output=%j.out



indices=/datastore/NGSF001/analysis/indices/human/GRCh38_Bowtie2_build
