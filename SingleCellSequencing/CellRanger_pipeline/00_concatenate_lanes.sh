#!/bin/bash
	

#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=8G
#SBATCH --account=hpc_p_anderson

set -eux
	
mkdir -p /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/analysis/Fastq 
# Move all fastq files from the run onto the node
FASTQ_FOLDER=/datastore/NGSF001/datasets/singlecell/Brain_Tumor_3p_fastqs
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/analysis/Fastq
	

for i in {1,2}
do
	cat ${FASTQ_FOLDER}/Brain_Tumor_3p_S2_L*_I${i}_001.fastq.gz > ${OUTDIR}/Brain_Tumor_3p_S2_L001_I${i}_001.fastq.gz
	cat ${FASTQ_FOLDER}/Brain_Tumor_3p_S2_L*_R${i}_001.fastq.gz > ${OUTDIR}/Brain_Tumor_3p_S2_L001_R${i}_001.fastq.gz
done
  
