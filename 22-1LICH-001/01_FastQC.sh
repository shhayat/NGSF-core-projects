#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=fastqc
#SBATCH --ntasks=6
#BATCH --cpus-per-task=4
#SBATCH --time=02:00:00
#SBATCH --mem=6G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux


module load fastqc
DATA=/datastore/NGSF001/projects/22-1LICH-001/fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1LICH-001/analysis

mkdir -p ${OUTDIR}/fastqc


for fq in $DATA/R2*_R*.fastq.gz
do
   fastqc -o ${OUTDIR}/fastqc --extract ${fq}
   
done 

wait 

cd /globalhome/hxo752/HPC/tools/
./multiqc ${OUTDIR}/fastqc/*_fastqc.zip -o ${OUTDIR}/fastqc

#for FASTQ_FILE in ${DATA}/*.fastq.gz
#do
  #fastqc
#  fastqc -o ${OUTDIR} --extract ${FASTQ_FILE}
#done
