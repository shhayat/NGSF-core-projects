#!/bin/bash
	
#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=6:00:00
#SBATCH --mem=40G

	
set -eux
	
FASTQ_FOLDER=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1TOSH-001/analysis/fastq_folders
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1JOHO-001/analysis/Fastq

mkdir -p ${OUTDIR}

for i in $(seq -w 53 121)
do
	echo Combining library R23000${i}
	cat ${FASTQ_FOLDER}/230505_NB551711_0069_AHLJGJBGXM/R23000${i}_*_R1_* \
	${FASTQ_FOLDER}/230511_NB551711_0072_AH5HTFBGXN/R23000${i}_S*_R1_001.fastq.gz \
	${FASTQ_FOLDER}/230516_NB551711_0074_AHV2N3BGXN/R23000${i}_S*_R1_001.fastq.gz \
	${FASTQ_FOLDER}/230510_NB551711_0071_AH5J3TBGXN/R23000${i}_S*_R1_001.fastq.gz \
	${FASTQ_FOLDER}/230512_NB551711_0073_AHV2MWBGXN/R23000${i}_S*_R1_001.fastq.gz > ${OUTDIR}/R23000${i}_R1.fastq.gz
	
	cat ${FASTQ_FOLDER}/230505_NB551711_0069_AHLJGJBGXM/R23000${i}_S*_R2_001.fastq.gz \
	${FASTQ_FOLDER}/230511_NB551711_0072_AH5HTFBGXN/R23000${i}_S*_R2_001.fastq.gz \
	${FASTQ_FOLDER}/230516_NB551711_0074_AHV2N3BGXN/R23000${i}_S*_R2_001.fastq.gz \
	${FASTQ_FOLDER}/230510_NB551711_0071_AH5J3TBGXN/R23000${i}_S*_R2_001.fastq.gz \
	${FASTQ_FOLDER}/230512_NB551711_0073_AHV2MWBGXN/R23000${i}_S*_R2_001.fastq.gz > ${OUTDIR}/R23000${i}_R2.fastq.gz
done
