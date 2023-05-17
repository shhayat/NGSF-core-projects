#!/bin/bash
	
#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=6:00:00
#SBATCH --mem=40G

	
set -eux
	
FASTQ_FOLDER=/datastore/NGSF001/projects/23-1TOSH-001/fastq_folders
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1JOHO-001/analysis/Fastq

mkdir -p ${OUTDIR}

#for i in $(seq -w 53 121);
#do
#	for j in $(seq -w 1 69);
#	do
#		echo Combining library R23000${i}
#		cat ${FASTQ_FOLDER}/230505_NB551711_0069_AHLJGJBGXM/R23000${i}_S${i}_R1_001.fastq.gz \
#		${FASTQ_FOLDER}/230511_NB551711_0072_AH5HTFBGXN/R23000${i}_S${i}_R1_001.fastq.gz \
#		${FASTQ_FOLDER}/230516_NB551711_0074_AHV2N3BGXN/R23000${i}_S${i}_R1_001.fastq.gz \
#		${FASTQ_FOLDER/230510_NB551711_0071_AH5J3TBGXN/R23000${i}_S${i}_R1_001.fastq.gz \
#		${FASTQ_FOLDER}/230512_NB551711_0073_AHV2MWBGXN/R23000${i}_S${i}_R1_001.fastq.gz > ${OUTDIR}/R23000${i}_R1.fastq.gz
	
#		cat ${FASTQ_FOLDER}/230505_NB551711_0069_AHLJGJBGXM/R23000${i}_S${i}_R2_001.fastq.gz \
#		${FASTQ_FOLDER}/230511_NB551711_0072_AH5HTFBGXN/R23000${i}_S${i}_R2_001.fastq.gz \
#		${FASTQ_FOLDER}/230516_NB551711_0074_AHV2N3BGXN/R23000${i}_S${i}_R2_001.fastq.gz \
#		${FASTQ_FOLDER}/230510_NB551711_0071_AH5J3TBGXN/R23000${i}_S${i}_R2_001.fastq.gz \
#		${FASTQ_FOLDER}/230512_NB551711_0073_AHV2MWBGXN/R23000${i}_S${i}_R2_001.fastq.gz > ${OUTDIR}/R23000${i}_R2.fastq.gz
#	done
#done


# Define the folders where the files are located
folders=("230505_NB551711_0069_AHLJGJBGXM" "230511_NB551711_0072_AH5HTFBGXN" "230516_NB551711_0074_AHV2N3BGXN" "230510_NB551711_0071_AH5J3TBGXN" "230512_NB551711_0073_AHV2MWBGXN")

# Loop through each folder
for folder in ${folders[@]}
do
for i in $(seq -w 53 121);
do
  # Concatenate the files using cat
  cat ${FASTQ_FOLDER}/${folder}/R2300${i}_*_R1_001.fastq.gz >> "${OUTDIR}/R23000${i}_R1.fastq.gz"
  cat ${FASTQ_FOLDER}/${folder}/R2300${i}_*_R2_001.fastq.gz >> "${OUTDIR}/R23000${i}_R2.fastq.gz"
done
done
