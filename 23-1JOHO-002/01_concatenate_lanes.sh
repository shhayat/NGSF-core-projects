#!/bin/bash
	
#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=8G

	
set -eux
	
mkdir -p /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1JOHO-002/analysis/Fastq 

FASTQ_FOLDER=/datastore/NGSF001/NB551711/230912_NB551711_0080_AH2FC3BGXV/Alignment_1/20230913_051559/Fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1JOHO-002/analysis/Fastq
	
for i in $(seq -w 1 4)
do
	echo Combining library SC230000${i}
	cat ${FASTQ_FOLDER}/SC230000${i}_*_R1_* > ${OUTDIR}/SC230000${i}_S1_L001_R1_001.fastq.gz
	cat ${FASTQ_FOLDER}/SC2300001${i}_*_R2_* > ${OUTDIR}/SC230000${i}S1_L001_R2_001.fastq.gz
done
