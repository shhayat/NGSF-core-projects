#!/bin/bash
	
#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=4:00:00
#SBATCH --mem=8G

	
set -eux
	
FASTQ_FOLDER=/datastore/TumorBiobank/4.\ Projects/Project\ 3\ -\ Dr\ Hopkins\ -\ TFRI\ -\ PR2C\ Cohortes/Terry\ Fox\ Research\ Institute/RNA
OUTDIR=/datastore/TumorBiobank/4.\ Projects/Project\ 3\ -\ Dr\ Hopkins\ -\ TFRI\ -\ PR2C\ Cohortes/Terry\ Fox\ Research\ Institute/RNA/Fastq
mkdir -p $OUTDIR	

for i in $(seq -w 688 706)
do
	echo Combining library Li39${i}
	cat ${FASTQ_FOLDER}/Li39${i}_*_R1_* > ${OUTDIR}/Li39${i}_R1.fastq.gz
	cat ${FASTQ_FOLDER}/Li39${i}_*_R2_* > ${OUTDIR}/Li39${i}_R2.fastq.gz
done
