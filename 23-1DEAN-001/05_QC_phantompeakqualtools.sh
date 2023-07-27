#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=QC
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=20G
#SBATCH  --output=%j.out

module load StdEnv/2020
module load r/4.2.1
module load samtools
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis

mkdir -p ${OUTDIR}/QC/phantompeakqualtools
sample_name=$1;

# Quality check
#phantompeakqualtools
cd /globalhome/hxo752/HPC/tools/phantompeakqualtools

#cross correlation
Rscript run_spp.R -c=${OUTDIR}/alignment/${sample_name}/${sample_name}.aligned_dedup.bam \
                  -s=0:1:500 \
                  -savp=${OUTDIR}/QC/phantompeakqualtools/xcor_${sample_name}.pdf \
                  -tmpdir=/globalhome/hxo752/HPC/tmp \
                  -out=${OUTDIR}/QC/phantompeakqualtools/xcor_metrics_${sample_name}.txt

module unload r/4.2.1
module unload samtools
