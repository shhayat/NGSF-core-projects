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
module load bcftools/1.13
module load gcc/9.3.0

bcftools view -i 'INFO/FREQ < 0.01' D23000043_snps_ReadDepth10_BaseQuality30.vcf > D23000043_snps_AF0.01.vcf
bcftools view -i 'INFO/FREQ < 0.01' D23000044_snps_ReadDepth10_BaseQuality30.vcf > D23000044_snps_AF0.01.vcf
