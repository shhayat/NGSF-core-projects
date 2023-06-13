#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=nf_rnafusion
#SBATCH --cpus-per-task=16
#SBATCH --mem=185G
#SBATCH --time=40:00:00
#SBATCH --output=%j.out

module --force purge
module load StdEnv/2020
module load nextflow/22.10.6
module load gentoo/2020
module load singularity/3.9.2

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma
star_indice=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/indices                              
fastq_dir=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/fastq

mkdir -p ${DIR}/analysis/nextflow

nextflow run nf-core/scrnaseq -profile singularity \
                              --input ${DIR}/samplesheet.csv \
                              --star_fusion \
                              --fusion_inspector \
                              --genome CanFam3.1 \
                              --star_index ${star_indice} \
                              --starfusion_build 'TRUE' \
                              --outdir ${DIR}/analysis/nextflow \
                              --max_memory '185.GB' \
                              --max_cpus 16
                              
