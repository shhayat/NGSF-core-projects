#!/bin/bash
	
#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=8G

	
set -eux
	
mkdir -p /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1JOHO-001/analysis/Fastq 

FASTQ_FOLDER=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1TOSH-001/analysis/fastq_folders
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1JOHO-001/analysis/Fastq


for i in $(seq -w 53 121)
do
	echo Combining library R22000${i}
	cat ${FASTQ_FOLDER}/2305*/R23000${i}_*_R1_* > ${OUTDIR}/R23000${i}_R1.fastq.gz
	cat ${FASTQ_FOLDER}/2305*/R23000${i}_*_R2_* > ${OUTDIR}/R23000${i}_R2.fastq.gz
done
