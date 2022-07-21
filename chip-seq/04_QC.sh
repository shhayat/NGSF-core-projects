#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=macs3
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=20G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module load r/4.1.2
samtools load samtools
OUTDIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis"

mkdir -p ${OUTDIR}/QC/phantompeakqualtools
sample_name=$1;

cd /globalhome/hxo752/HPC/tools/phantompeakqualtools

Rscript run_spp.R -c=${OUTDIR}/alignment/${sample_name}/${sample_name}.aligned_dedup.bam -savp=xcor_${sample_name}.pdf -odir=${OUTDIR}/QC/phantompeakqualtools -out=xcor_metrics_${sample_name}.txt
