#!/bin/bash
	
#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=8G
#SBATCH --account=hpc_p_anderson

set -eux
	
mkdir -p /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/test/analysis/Fastq
# Move all fastq files from the run onto the node
FASTQ_FOLDER=/datastore/NGSF001/projects/20-1STSI-001-2663664/Fastq_File
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/test/analysis/Fastq
	

for i in {63,64}
do
	cat ${FASTQ_FOLDER}/D20000${i}_S*_*_R1_001.fastq.gz > ${OUTDIR}/D20000${i}_R1_001.fastq.gz
	cat ${FASTQ_FOLDER}/D20000${i}_S*_*_R2_001.fastq.gz > ${OUTDIR}/D20000${i}_R2_001.fastq.gz
done
