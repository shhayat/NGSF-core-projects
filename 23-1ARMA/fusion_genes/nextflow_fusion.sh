#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=nf_rnafusion
#SBATCH --cpus-per-task=16
#SBATCH --mem=80G
#SBATCH --time=40:00:00
#SBATCH --output=%j.out

module --force purge
module load StdEnv/2020
module load nextflow/22.10.6
module load gentoo/2020
module load singularity/3.9.2

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma
#star_indice=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/indices                              

mkdir -p ${DIR}/analysis/nextflow
mkdir -p ${DIR}/analysis/nextflow/work
nextflow run nf-core/rnafusion -r 2.3.4 \
                              -profile singularity \
                              --input ${DIR}/samplesheet.csv \
                              --outdir ${DIR}/analysis/nextflow \
                              -w ${DIR}/analysis/nextflow/work \
                              --genome 'CanFam3.1' \
                              --star_fusion \
                              --fusion_inspector \
                              --starfusion_build 'TRUE' \
                              --max_memory '80.GB' \
                              --max_cpus 16 \
                              -resume
# #  --fasta ${FASTA} \
#  --genomes_base ${REF} \
#--star_index ${star_indice} \
