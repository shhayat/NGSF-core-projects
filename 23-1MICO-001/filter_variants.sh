#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=varaint_calling
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=08:00:00
#SBATCH --mem=20G
#SBATCH  --output=%j_filterSNPs.out


module load StdEnv/2020
module load gcc/9.3.0
module load bcftools/1.13

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/SNPs_using_varscan2
bcftools view -i 'INFO/FREQ < 0.01' ${DIR}/D23000043_snps_ReadDepth10_BaseQuality30.vcf > ${DIR}/D23000043_snps_AF0.01.vcf
bcftools view -i 'INFO/FREQ < 0.01' ${DIR}/D23000044_snps_ReadDepth10_BaseQuality30.vcf > ${DIR}/D23000044_snps_AF0.01.vcf
