#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=QC
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=20G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module load r/4.1.2
module load samtools
OUTDIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis"

mkdir -p ${OUTDIR}/QC/phantompeakqualtools
sample_name=$1;

#using two QC tools for Quality check
#phantompeakqualtools
cd /globalhome/hxo752/HPC/tools/phantompeakqualtools

#cross correlation
Rscript run_spp.R -c=${OUTDIR}/alignment/${sample_name}/${sample_name}.aligned_sort.bam -savp=${OUTDIR}/QC/phantompeakqualtools/xcor_${sample_name}.pdf -out=${OUTDIR}/QC/phantompeakqualtools/xcor_metrics_${sample_name}.txt

module unload r/4.1.2
module unload samtools
