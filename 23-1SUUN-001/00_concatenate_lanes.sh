#!/bin/bash
	
#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=8G

	
set -eux
	
mkdir -p /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SUUN-001/analysis/fastq 

FASTQ_FOLDER=/datastore/NGSF001/NB551711/230711_NB551711_0076_AH727NBGXT/Alignment_1/20230712_000715/Fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SUUN-001/analysis/fastq
	

for i in $(seq -w 131 142)
do
	echo Combining library R2300${i}
	cat ${FASTQ_FOLDER}/R23000${i}_*_R1_* > ${OUTDIR}/R23000${i}_R1.fastq.gz
	cat ${FASTQ_FOLDER}/R23000${i}_*_R2_* > ${OUTDIR}/R23000${i}_R2.fastq.gz
done
  
