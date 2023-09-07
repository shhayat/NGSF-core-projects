#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=filter_variants
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=4:00:00
#SBATCH --mem=20G
#SBATCH  --output=%j_variant_quality.out

module load gatk/4.2.5.0

REF=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/genome/genome.fa
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/variants

#select only snps from vcf file
#gatk SelectVariants \
#    -R ${REF} \
#    -V SNP.recalibrated_99.9.vcf.gz \
#    --select-type-to-include SNP \
#    -O snps.vcf

#select rare variants
    gatk SelectVariants \
    -R ${REF} \
    -V ${OUTDIR}/SNP.recalibrated_99.9.vcf.gz \
    --select "AF <= 0.01" \
    -O ${OUTDIR}/rare_SNPs.vcf
