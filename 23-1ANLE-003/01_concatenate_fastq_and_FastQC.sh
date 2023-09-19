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

FASTQ_FOLDER=/datastore/NGSF001/NB551711/230913_NB551711_0081_AH2FC2BGXV/Alignment_1/20230914_033142/Fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANLE-003/analysis

mkdir -p ${OUTDIR}/fastqc

for i in $(seq -w 05 08)
do
	echo Combining library SC23000${i}
	cat ${FASTQ_FOLDER}/SC23000${i}_*_R1_* > ${OUTDIR}/SC23000${i}_R1.fastq.gz
	cat ${FASTQ_FOLDER}/SC23000${i}_*_R2_* > ${OUTDIR}/SC23000${i}_R2.fastq.gz
done

for fq in $DATA/*.fastq.gz
do
   fastqc -o ${OUTDIR}/fastqc --extract ${fq}
   
done
wait 

rm ${OUTDIR}/SC23000${i}_R1.fastq.gz
rm ${OUTDIR}/SC23000${i}_R2.fastq.gz

cd /globalhome/hxo752/HPC/tools
multiqc ${OUTDIR}/fastqc/*_fastqc.zip -o ${OUTDIR}/fastqc
