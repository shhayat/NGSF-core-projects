#!/bin/bash
	
#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=8G

set -eux

mkdir -p /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANLE-004/analysis/fastq 
FASTQ_FOLDER=/datastore/NGSF001/NB551711/230915_NB551711_0082_AHNHKFAFX5/Alignment_1/20230916_014510/Fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANLE-004/analysis/fastq
	
for i in $(seq -w 161 166)
do
	echo Combining library R2300${i}
	cat ${FASTQ_FOLDER}/R2300${i}_*_R1_* > ${OUTDIR}/R2300${i}_R1.fastq.gz
	cat ${FASTQ_FOLDER}/R2300${i}_*_R2_* > ${OUTDIR}/R2300${i}_R2.fastq.gz
done
