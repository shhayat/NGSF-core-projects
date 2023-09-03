#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=markdup_add_RG
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=2:30:00
#SBATCH --mem=64G
#SBATCH  --output=recalibrate.out

module laod 

DIR=
OUTDIR=
sample_name=1

gatk BaseRecalibrator \
   -I ${DIR}/${sample_name}/${sample_name}_mdup_rg_sort.bam \
   -R reference.fasta \
   --known-sites sites_of_variation.vcf \
   --known-sites another/optional/setOfSitesToMask.vcf \
   -O ${OUTDIR}/${sample_name}/${sample_name}_recal_data.table

  gatk ApplyVQSR \
   -R Homo_sapiens_assembly38.fasta \
   -V input.vcf.gz \
   -O output.vcf.gz \
   --truth-sensitivity-filter-level 99.0 \
   --tranches-file output.tranches \
   --recal-file output.recal \
   -mode SNP
