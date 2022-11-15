#!/bin/bash
	
#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=8G
#SBATCH --account=hpc_p_anderson
	
set -eux
	
mkdir -p /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1BETO-001B/analysis/Fastq 
# Move all fastq files from the run onto the node
FASTQ_FOLDER=/datastore/NGSF001/NB551711/221108_NB551711_0060_AHK53KBGXL/Alignment_1/20221108_225459/Fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1BETO-001B/analysis/Fastq
	

for i in $(seq -w 166 177)
do
	echo Combining library R22000${i}
        # Cat all the original seq (each lane) files into a new file on the node
	# This will also remove that stupid sample number
	cat ${FASTQ_FOLDER}/R22000${i}_*_R1_* > ${OUTDIR}/R22000${i}_R1.fastq.gz
	cat ${FASTQ_FOLDER}/R22000${i}_*_R2_* > ${OUTDIR}/R22000${i}_R2.fastq.gz
done
