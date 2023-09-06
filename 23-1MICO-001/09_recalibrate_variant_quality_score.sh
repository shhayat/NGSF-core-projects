#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=variant_quality
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=4:00:00
#SBATCH --mem=20G
#SBATCH  --output=%j_variant_quality.out

module load gatk/4.2.5.0 
#https://gatk.broadinstitute.org/hc/en-us/articles/360036510892-VariantRecalibrator

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/variants/
 gatk VariantRecalibrator \
   -R Homo_sapiens_assembly38.fasta \
   -V ${sample_name}.vcf.gz \
   --resource hapmap,known=false,training=true,truth=true,prior=15.0:hapmap_3.3.hg38.sites.vcf.gz \
   --resource omni,known=false,training=true,truth=false,prior=12.0:1000G_omni2.5.hg38.sites.vcf.gz \
   --resource 1000G,known=false,training=true,truth=false,prior=10.0:1000G_phase1.snps.high_confidence.hg38.vcf.gz \
   --resource dbsnp,known=true,training=false,truth=false,prior=2.0:Homo_sapiens_assembly38.dbsnp138.vcf.gz \
   -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR \
   -mode SNP \
   -O output.recal \
   --tranches-file output.tranches \
   --rscript-file output.plots.R
