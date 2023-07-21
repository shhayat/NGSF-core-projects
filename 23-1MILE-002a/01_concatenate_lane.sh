#!/bin/bash
	
#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=8G

mkdir -p /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002a/analysis/Fastq 

FASTQ_FOLDER=/datastore/NGSF001/NB551711/230718_NB551711_0078_AHL2L5AFX5/Alignment_1/20230719_041051/Fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002a/analysis/Fastq
	

for i in $(seq -w 122 129)
do
	echo Combining library R2300${i}
	cat ${FASTQ_FOLDER}/R2300${i}_*_R1_* > ${OUTDIR}/R2300${i}_R1.fastq.gz
	cat ${FASTQ_FOLDER}/R2300${i}_*_R2_* > ${OUTDIR}/R2300${i}_R2.fastq.gz
done


