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

NCPU=4
cd /globalhome/hxo752/HPC/tools/bowtie2-2.4.5-linux-x86_64
GENOME=/datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects//analysis/

bowtie2-build ${GENOME}/genome.fa ${OUTDIR}/bowtie_index
