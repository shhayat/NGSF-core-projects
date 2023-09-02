#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=4
#SBATCH --time=10:00:00
#SBATCH --mem=60G
#SBATCH --output=%j.out
set -eux

module load bowtie2/2.5.1
GENOME=/datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/indices

bowtie2-build ${GENOME}/genome.fa ${OUTDIR}/bowtie_index
