#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=fastqc
#SBATCH --ntasks=6
#BATCH --cpus-per-task=10
#SBATCH --time=02:00:00
#SBATCH --mem=20G
#SBATCH --output=%j.out
set -eux

module load fastqc
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/Fibrosarcoma
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/Variant_analysis_pipeline

mkdir -p ${OUTDIR}/analysis/fastqc/Fibrosarcoma

for fq in $DATA/fastq/SRR*.fastq.gz
do
   fastqc -o ${OUTDIR}/fastqc --extract ${fq}
   
done 

wait 

cd /datastore/NGSF001/software/tools/
./multiqc ${OUTDIR}/fastqc/*_fastqc.zip -o ${OUTDIR}/Fibrosarcoma/fastqc


DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/Normal_Skin
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/Variant_analysis_pipeline

mkdir -p ${OUTDIR}/analysis/fastqc/Normal_Skin

for fq in $DATA/fastq/SRR*.fastq.gz
do
   fastqc -o ${OUTDIR}/fastqc --extract ${fq}
   
done 

wait 

cd /datastore/NGSF001/software/tools/
./multiqc ${OUTDIR}/fastqc/*_fastqc.zip -o ${OUTDIR}/Normal_Skin/fastqc
