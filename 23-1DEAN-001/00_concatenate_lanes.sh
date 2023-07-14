#!/bin/bash
	
#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=8G

	
set -eux
	
mkdir -p /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/fastq 

FASTQ_FOLDER=/datastore/NGSF001/NB551711/230713_NB551711_0077_AHGWY7BGXT/Alignment_1/20230713_234249/Fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SUUN-001/analysis/fastq
	

for i in $(seq -w 131 142)
do
	echo Combining library R2300${i}
	cat ${FASTQ_FOLDER}/R2300${i}_*_R1_* > ${OUTDIR}/R2300${i}.fastq.gz
done
