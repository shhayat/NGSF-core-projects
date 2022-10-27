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
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-BETO-001/Fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-BETO-001

mkdir -p ${OUTDIR}/analysis/fastqc

for fq in $DATA/R22*.fastq.gz
do
   fastqc -o ${OUTDIR}/analysis/fastqc --extract ${fq}
   
done 

wait 

cd /datastore/NGSF001/software/tools/
./multiqc ${OUTDIR}/analysis/fastqc/*_fastqc.zip -o ${OUTDIR}/fastqc
