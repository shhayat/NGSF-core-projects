#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=fastqc
#SBATCH --ntasks=6
#SBATCH --cpus-per-task=2
#SBATCH --time=02:00:00
<<<<<<< HEAD
#SBATCH --mem=4G
=======
#SBATCH --mem=6G
>>>>>>> 4bc79c04055a0b48d85baa7a404d8c71bb933dbc
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux


module load fastqc
DATA=/datastore/NGSF001/projects/22-1LICH-001/fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1LICH-001

mkdir -p ${OUTDIR}/fastqc

pids=""
for fq in $DATA/R2*_R*.fastq.gz
do
   fastqc -o ${OUTDIR}/fastqc --extract ${fq}
   pids="$pids $!"
done 

wait $pids 

cd /globalhome/hxo752/HPC/tools/
./multiqc ${OUTDIR}/fastqc/*_fastqc.zip -o ${OUTDIR}/fastqc

#for FASTQ_FILE in ${DATA}/*.fastq.gz
#do
  #fastqc
#  fastqc -o ${OUTDIR} --extract ${FASTQ_FILE}
#done
