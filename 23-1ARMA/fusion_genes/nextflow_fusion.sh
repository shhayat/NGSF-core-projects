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
star_indice=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/indices                              
REF=/datastore/NGSF001/analysis/references/iGenomes/Dog/Canis_familiaris/Ensembl/CanFam3.1/Sequence/WholeGenomeFasta
FASTA=/datastore/NGSF001/analysis/references/iGenomes/Dog/Canis_familiaris/Ensembl/CanFam3.1/Sequence/WholeGenomeFasta/genome.fa
#FASTA_FAI=/datastore/NGSF001/analysis/references/iGenomes/Dog/Canis_familiaris/Ensembl/CanFam3.1/Sequence/WholeGenomeFasta/genome.fa.fai
#GTF=/datastore/NGSF001/analysis/references/iGenomes/Dog/Canis_familiaris/Ensembl/CanFam3.1/Annotation/Genes/genes.gtf
mkdir -p ${DIR}/analysis/nextflow

nextflow run nf-core/rnafusion -profile singularity \
                              --input ${DIR}/samplesheet.csv \
                              --outdir ${DIR}/analysis/nextflow \
                              --star_fusion \
                              --fusion_inspector \
                              --genomes_base ${REF} \
                              --fasta ${FASTA} \
                              --star_index ${star_indice} \
                              --starfusion_build 'TRUE' \
                              --max_memory '80.GB' \
                              --max_cpus 16 \
