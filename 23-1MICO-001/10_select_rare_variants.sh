#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=filter_variants
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:30:00
#SBATCH --mem=5G
#SBATCH  --output=%j_filter_variants.out

module load gatk/4.2.5.0

REF=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/genome/genome.fa
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/variants

#select only snps from vcf file
#gatk SelectVariants \
#    -R ${REF} \
#    -V SNP.recalibrated_99.9.vcf.gz \
#    --select-type-to-include SNP \
#    -O snps.vcf

#select rare variants with base quality >=30 && mapping quality >=20 && AF <= 0.01
#gatk SelectVariants \
#    -R ${REF} \
#    -V ${OUTDIR}/SNP.recalibrated_99.9.vcf.gz \
#    --select "MQ >= 30.0 && QUAL >= 20.0 && AF <= 0.01" \
#    -O ${OUTDIR}/rare_SNPs.vcf

gatk SelectVariants \
    -R ${REF} \
    -V ${OUTDIR}/genotyped.g.vcf.gz \
    -select AF < 0.60 \
    -O ${OUTDIR}/rare_SNPs.vcf
