#!/bin/bash
	

#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=8G
#SBATCH --account=hpc_p_anderson

	
set -eux
	
mkdir -p /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/fastq_concatenated
# Move all fastq files from the run onto the node
FASTQ_FOLDER=/datastore/NGSF001/projects/2021/21-1MILE-001/fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/fastq_concatenated
	

for i in $(seq -w 154 165)
do
	echo Combining library R22000${i}
        # Cat all the original seq (each lane) files into a new file on the node
	cat ${FASTQ_FOLDER}/R22000${i}_*_R1_* > ${OUTDIR}/R22000${i}_R1.fastq.gz
	cat ${FASTQ_FOLDER}/R22000${i}_*_R2_* > ${OUTDIR}/R22000${i}_R2.fastq.gz
done
