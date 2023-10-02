#!/bin/bash
	
#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=3:00:00
#SBATCH --mem=8G

set -eux
mkdir -p /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001/analysis/fastq 
FASTQ_FOLDER1=/datastore/NGSF001/NB551711/230919_NB551711_0083_AH2FG5BGXV/Alignment_1/20230920_064527/Fastq
OUTDIR1=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001/analysis/fastq

#First concatenate Lanes for latest samples
for i in $(seq -w 143 168)
do
	echo Combining library R2300${i}
	cat ${FASTQ_FOLDER1}/R2300${i}_*_R1_* > ${OUTDIR1}/R2300${i}_R1.fastq.gz
	cat ${FASTQ_FOLDER1}/R2300${i}_*_R2_* > ${OUTDIR1}/R2300${i}_R2.fastq.gz
done

FASTQ_FOLDER2=/datastore/NGSF001/projects/22-1LICH-001/fastq
OUTDIR2=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001/analysis/concatenated_latest_fastq_with_previous_fastq
mkdir -p ${OUTDIR2}

#Concatenate 22-1LICH-001 with latest samples
#A3A U6
cat ${FASTQ_FOLDER2}/R2300132_R1.fastq.gz ${OUTDIR1}/R2300143_R1.fastq.gz > ${OUTDIR2}/A3A_U6_R1.fastq.gz
cat ${FASTQ_FOLDER2}/R2300132_R2.fastq.gz ${OUTDIR1}/R2300143_R2.fastq.gz > ${OUTDIR2}/A3A_U6_R2.fastq.gz
#A3A I5
cat ${FASTQ_FOLDER2}/R2300133_R1.fastq.gz ${OUTDIR1}/R2300144_R1.fastq.gz > ${OUTDIR2}/A3A_I5_R1.fastq.gz
cat ${FASTQ_FOLDER2}/R2300133_R2.fastq.gz ${OUTDIR1}/R2300144_R2.fastq.gz > ${OUTDIR2}/A3A_I5_R2.fastq.gz
#A3A I4 (1)(2)
cat ${OUTDIR1}/R2300150_R1.fastq.gz ${OUTDIR1}/R2300152_R1.fastq.gz > ${OUTDIR2}/A3A_I4_R1.fastq.gz
cat ${OUTDIR1}/R2300150_R2.fastq.gz ${OUTDIR1}/R2300152_R2.fastq.gz > ${OUTDIR2}/A3A_I4_R2.fastq.gz
#A3A U1 (1)(2)
cat ${OUTDIR1}/R2300149_R1.fastq.gz ${OUTDIR1}/R2300151_R1.fastq.gz > ${OUTDIR2}/A3A_U1_R1.fastq.gz
cat ${OUTDIR1}/R2300149_R2.fastq.gz ${OUTDIR1}/R2300151_R2.fastq.gz > ${OUTDIR2}/A3A_U1_R2.fastq.gz


#A3B U2
cat ${FASTQ_FOLDER2}/R2300134_R1.fastq.gz ${OUTDIR1}/R2300145_R1.fastq.gz > ${OUTDIR2}/A3B_U2_R1.fastq.gz
cat ${FASTQ_FOLDER2}/R2300134_R2.fastq.gz ${OUTDIR1}/R2300145_R2.fastq.gz > ${OUTDIR2}/A3B_U2_R2.fastq.gz
#A3B I5
cat ${FASTQ_FOLDER2}/R2300135_R1.fastq.gz ${OUTDIR1}/R2300146_R1.fastq.gz > ${OUTDIR2}/A3B_I5_R1.fastq.gz
cat ${FASTQ_FOLDER2}/R2300135_R1.fastq.gz ${OUTDIR1}/R2300146_R2.fastq.gz > ${OUTDIR2}/A3B_I5_R2.fastq.gz
#A3B U1 (1)(2)
cat ${OUTDIR1}/R2300153_R1.fastq.gz ${OUTDIR1}/R2300168_R1.fastq.gz > ${OUTDIR2}/A3B_U1_R1.fastq.gz
cat ${OUTDIR1}/R2300153_R2.fastq.gz ${OUTDIR1}/R2300168_R2.fastq.gz > ${OUTDIR2}/A3B_U1_R2.fastq.gz
#A3B I2 (1)(2)
cat ${OUTDIR1}/R2300154_R1.fastq.gz ${OUTDIR1}/R2300156_R1.fastq.gz > ${OUTDIR2}/A3B_U2_R1.fastq.gz
cat ${OUTDIR1}/R2300154_R2.fastq.gz ${OUTDIR1}/R2300156_R2.fastq.gz > ${OUTDIR2}/A3B_U2_R2.fastq.gz


#A3H U1
cat ${FASTQ_FOLDER2}/R2300136_R1.fastq.gz ${OUTDIR1}/R2300147_R1.fastq.gz > ${OUTDIR2}/A3H_U1_R1.fastq.gz
cat ${FASTQ_FOLDER2}/R2300136_R2.fastq.gz ${OUTDIR1}/R2300147_R2.fastq.gz > ${OUTDIR2}/A3H_U1_R2.fastq.gz
#A3H U2 (1)(2)
cat ${OUTDIR1}/R2300157_R1.fastq.gz ${OUTDIR1}/R2300159_R1.fastq.gz > ${OUTDIR2}/A3H_U2_R1.fastq.gz
cat ${OUTDIR}/R2300157_R2.fastq.gz ${OUTDIR1}/R2300159_R2.fastq.gz > ${OUTDIR2}/A3H_U2_R2.fastq.gz
#A3H I4
cat ${FASTQ_FOLDER2}/R2300137_R1.fastq.gz ${OUTDIR1}/R2300167_R1.fastq.gz > ${OUTDIR2}/A3H_I4_R1.fastq.gz
cat ${FASTQ_FOLDER2}/R2300137_R1.fastq.gz ${OUTDIR1}/R2300167_R2.fastq.gz > ${OUTDIR2}/A3H_I4_R2.fastq.gz
#A3H I1
cat ${OUTDIR1}/R2300158_R1.fastq.gz ${OUTDIR1}/R2300160_R1.fastq.gz > ${OUTDIR2}/A3H_I1_R1.fastq.gz
cat ${OUTDIR1}/R2300158_R1.fastq.gz ${OUTDIR1}/R2300160_R2.fastq.gz > ${OUTDIR2}/A3H_I1_R2.fastq.gz
