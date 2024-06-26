#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=rm_\shared_variants
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

#removed shared variants between D23000043 and D23000044. Selected variants unique to D23000043
bcftools isec \
-C \
-c none \
-o ${DIR}/unique_to_D23000043.vcf \
-w 1 \
${DIR}/D23000043_snps_ReadDepth20_BaseQuality30.vcf.gz ${DIR}/D23000044_snps_ReadDepth20_BaseQuality30.vcf.gz

bcftools isec -n=2 \
-c all \
-o ${DIR}/shared_snps.vcf \
-w 1 \
${DIR}/D23000043_snps_ReadDepth20_BaseQuality30.vcf.gz ${DIR}/D23000044_snps_ReadDepth20_BaseQuality30.vcf.gz       
