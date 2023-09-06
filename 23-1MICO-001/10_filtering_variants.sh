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

REF=
OUTDIR=
#select only snps from vcf file
gatk SelectVariants \
    -R reference.fasta \
    -V input.vcf \
    --select-type-to-include SNP \
    -O snps.vcf

#select rare variants
    gatk SelectVariants \
    -R reference.fasta \
    -V input.vcf \
    --select "AF <= 0.01" \
    -O rare_variants.vcf
