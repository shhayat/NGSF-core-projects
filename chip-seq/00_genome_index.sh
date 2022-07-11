#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=6
#SBATCH --time=04:00:00
#SBATCH --mem=40G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

cd /globalhome/hxo752/HPC/tools/bowtie2-2.4.5-linux-x86_64
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/indices
mkdir -p ${OUTDIR}

rsync -avzP /datastore/NGSF001/analysis/references/human/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta ${SLURM_TMPDIR}/

./bowtie2-build ${SLURM_TMPDIR}/genome.fa \
${OUTDIR}/Homo_sapiens_NCBI_GRCh38_index
