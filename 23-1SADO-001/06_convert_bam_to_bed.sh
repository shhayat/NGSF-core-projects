#!/bin/bash
#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=bamcoverage
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:30:00
#SBATCH --mem=2G
#SBATCH  --output=%j.out

##loading required modules for bedtools
module load nixpkgs/16.09 
module load gcc/5.4.0
module load intel/2016.4
module load intel/2017.1
module load bedtools

##loading required modules for tabix
module load StdEnv/2020
module load nixpkgs/16.09  
module load intel/2016.4
module load tabix/0.2.6

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SADO-001/analysis/star_alignment
deeptools=/globalhome/hxo752/HPC/.local/lib/python3.7/site-packages/deeptools/
SAMPLE_NAME=$1;
BAM=$2;

#bedtools bamtobed -i ${DIR}/${SAMPLE_NAME}/${BAM} > ${DIR}/${SAMPLE_NAME}/${SAMPLE_NAME}.bed
#bedtools genomecov -ibam ${DIR}/${SAMPLE_NAME}/${BAM} -bg ${DIR}/${SAMPLE_NAME}/${SAMPLE_NAME}_cov.bed
#bedtools sort ${DIR}/${SAMPLE_NAME}/${SAMPLE_NAME}_cov.bed > ${DIR}/${SAMPLE_NAME}/${SAMPLE_NAME}_cov_sorted.bed
#tabix -pbed ${DIR}/${SAMPLE_NAME}/${SAMPLE_NAME}_cov_sorted.bed

/globalhome/hxo752/HPC/anaconda3/envs/deeptools/bin --bam ${DIR}/${SAMPLE_NAME}/${BAM} \
                                                    --outFileName ${SAMPLE_NAME} \
                                                    --outFileFormat bedgraph
          
