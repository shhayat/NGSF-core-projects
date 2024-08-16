#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=trim
#SBATCH --ntasks=1
#BATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=5G
#SBATCH --output=/project/anderson/%j.out

sample_name=$1;

trim_galore=/$HOME/venvs/trim-glore/TrimGalore-0.6.10
${trim_galore}/trim_galore \
                           --paired ${sample_name}_R1_read_trimmed.fq.gz ${sample_name}_R2_read_trimmed.fq.gz \
                           --cores ${NCPU} \
                           --illumina
