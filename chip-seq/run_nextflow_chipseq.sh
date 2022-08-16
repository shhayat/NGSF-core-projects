#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=nf_chipseq
#SBATCH --cpus-per-task=40
#SBATCH --mem=185G
#SBATCH --time=10:00:00
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

#module --force purge
module spider nextflow/22.04.3
module spider singularity/3.4.1


nextflow run nf-core/chipseq -profile singularity --input chip_design.csv --genome GRCm38 --single_end true --gtf 
