#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=8
#SBATCH --time=72:00:00
#SBATCH --mem=120G
#SBATCH --output=%j.out

module load bowtie2/2.5.1

#GENOME=/datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta
GENOME=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/genome
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/indices

mkdir -p $OUTDIR
bowtie2-build ${GENOME}/genome.fa ${OUTDIR}/bowtie_index
#bowtie2-build ${GENOME}/GCF_000001405.40_GRCh38.p14_genomic.fna ${OUTDIR}/bowtie_index
