#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=homer-annotate-peaks
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

cd /globalhome/hxo752/HPC/anaconda3/share/homer/bin

OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/analysis/homer
GTF=/datastore/NGSF001/analysis/references/human/iGenomes/Homo_sapiens/NCBI/GRCh38/Annotation/Genes/genes.gtf

mkdir -p $OUTDIR
sample_name=$1;

./annotatePeaks.pl ERpeaks.txt hg18 -gtf ${GTF} > ${OUTDIR}/{sample_name}_annotated_peaks.txt
