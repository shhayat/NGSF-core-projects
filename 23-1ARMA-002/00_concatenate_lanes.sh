#!/bin/bash
	
#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=5:00:00
#SBATCH --mem=8G

	
set -eux
	
mkdir -p /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA-002/analysis/Fastq 

FASTQ_FOLDER=/datastore/NGSF001/NB551711/231219_NB551711_0089_AHKH3NBGXV/Alignment_1/20231220_044335/Fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA-002/analysis/Fastq
	

for i in $(seq -w 19 22)
do
	echo Combining library SC23000${i}
	cat ${FASTQ_FOLDER}/SC23000${i}_*_R1_* > ${OUTDIR}/R2300${i}_R1.fastq.gz
 	cat ${FASTQ_FOLDER1}/R2300${i}_*_R2_* > ${OUTDIR}/R2300${i}_R2.fastq.gz
done
