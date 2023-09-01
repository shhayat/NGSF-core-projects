#!/bin/bash
	
#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=8G

	
set -eux
	

FASTQ_FOLDER=/datastore/NGSF001/NB551711/230801_NB551711_0079_AHL2K5AFX5/Alignment_1/20230802_081815/Fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/Fastq
mkdir -p ${OUTDIR}	

for i in {43..44}
do
	echo Combining library D230000${i}
	cat ${FASTQ_FOLDER}/D230000${i}_*_R1_* > ${OUTDIR}/D230000${i}_R1.fastq.gz
	cat ${FASTQ_FOLDER}/R23000${i}_*_R2_* > ${OUTDIR}/D230000${i}_R2.fastq.gz
done
  
