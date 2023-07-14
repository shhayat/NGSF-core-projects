#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=4
#SBATCH --time=10:00:00
#SBATCH --mem=60G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

NCPU=4
cd /globalhome/hxo752/HPC/tools/bowtie2-2.4.5-linux-x86_64
#OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/indices
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/indices_mouse
mkdir -p ${OUTDIR}

./bowtie2-build ${OUTDIR}/genome.fa ${OUTDIR}/bowtie_GRCh38 --threads ${NCPU}
