#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=rm_shared_variants
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=02:00:00
#SBATCH --mem=20G
#SBATCH  --output=%j_rm_shared_variants.out

#loading required modules
module load StdEnv/2020
module load gcc/9.3.0
module load bcftools/1.13

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/SNPs_using_varscan2

bcftools isec -n=1 \
-c none \
-o ${DIR}/unique_variants \
-p ${DIR} \
${DIR}/D23000043_snps_ReadDepth10_BaseQuality30.vcf ${DIR}/D23000044_snps_ReadDepth10_BaseQuality30.vcf

bcftools view -O z \
-o unique_file1.vcf.gz ${DIR}/0000.vcf



bcftools index -t ${DIR}/${DIR}/D23000043_snps_unique.vcf.gz.gz