#!/bin/bash
	
#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=8G

	
set -eux
	
mkdir -p /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SCWI-001/analysis/Fastq 

FASTQ_FOLDER1=/datastore/NGSF001/NB551711/231122_NB551711_0087_AHK2NHBGXV/Alignment_1/20231123_013827/Fastq
FASTQ_FOLDER2=/datastore/NGSF001/NB551711/231123_NB551711_0088_AHK2TKBGXV/Alignment_1/20231124_020057/Fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SCWI-001/analysis/Fastq
	

for i in $(seq -w 181 204)
do
	echo Combining library R300${i}
	cat ${FASTQ_FOLDER1}/R2300${i}_*_R1_* > ${OUTDIR}/R2300${i}_R1.fastq.gz
	cat ${FASTQ_FOLDER1}/R23000${i}_*_R2_* > ${OUTDIR}/R2300${i}_R2.fastq.gz
done
