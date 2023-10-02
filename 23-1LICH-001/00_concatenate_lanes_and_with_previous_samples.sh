#!/bin/bash
	
#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=8G

set -eux
mkdir -p /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001/analysis/fastq 
FASTQ_FOLDER=/datastore/NGSF001/NB551711/230919_NB551711_0083_AH2FG5BGXV/Alignment_1/20230920_064527/Fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANLE-004/analysis/fastq

#/datastore/NGSF001/projects/22-1LICH-001/fastq

for i in $(seq -w 143 168)
do
	echo Combining library R2300${i}
	cat ${FASTQ_FOLDER}/R2300${i}_*_R1_* > ${OUTDIR}/R2300${i}_R1.fastq.gz
	cat ${FASTQ_FOLDER}/R2300${i}_*_R2_* > ${OUTDIR}/R2300${i}_R2.fastq.gz
done
