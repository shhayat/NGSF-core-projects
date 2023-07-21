#!/bin/bash
	
#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=8G

mkdir -p /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002a/analysis/Fastq 
mkdir -p /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002a/analysis/fastq_concatenated 

#current samples
FASTQ_FOLDER1=/datastore/NGSF001/NB551711/230718_NB551711_0078_AHL2L5AFX5/Alignment_1/20230719_041051/Fastq
#previous samples
FASTQ_FOLDER2=/datastore/NGSF001/projects/23-1MILE-002/fastq
OUTDIR1=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002a/analysis/Fastq
OUTDIR2=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002a/analysis/fastq_concatenated	

#for i in $(seq -w 122 129)
#do
#	echo Combining library R2300${i}
#	cat ${FASTQ_FOLDER1}/R2300${i}_*_R1_* > ${OUTDIR}/R2300${i}_R1.fastq.gz
#	cat ${FASTQ_FOLDER1}/R2300${i}_*_R2_* > ${OUTDIR}/R2300${i}_R2.fastq.gz
#done

#wait

#2 samples 127 and 130 are not concatenated because they were not sequenced in second run
for i in 122 133 124 125 126 128 129
do
	echo "Combining 23-1MILE-002 fastq samples with 23-1MILE-002a"
	cat ${OUTDIR1}/R2300${i}_R1.fastq.gz ${FASTQ_FOLDER2}/R2300${i}_*_R1_001.fastq.gz > ${OUTDIR2}/R2300${i}_R1.fastq.gz
	cat ${OUTDIR1}/R2300${i}_R2.fastq.gz ${FASTQ_FOLDER2}/R2300${i}_*_R2_001.fastq.gz > ${OUTDIR2}/R2300${i}_R2.fastq.gz
done

