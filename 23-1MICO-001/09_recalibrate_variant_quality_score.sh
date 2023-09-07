#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=variant_quality
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=6:00:00
#SBATCH --mem=20G
#SBATCH  --output=%j_variant_quality.out

#https://gatk.broadinstitute.org/hc/en-us/articles/360036510892-VariantRecalibrator
module load gatk/4.2.5.0 

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/variants
REF=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/genome/genome.fa
gatk_resource=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/gatk_resource_bundle

cd ${gatk_resource}
mkdir -p ${DIR}

#  select SNP in while variant recalibration
gatk --java-options "-Xms20G -Xmx20G -XX:ParallelGCThreads=2" VariantRecalibrator \
   -R ${REF} \
   -V ${DIR}/genotyped.g.vcf.gz \
   --resource hapmap,known=false,training=true,truth=true,prior=15.0:hapmap_3.3.hg38.sites.vcf.gz \
   --resource omni,known=false,training=true,truth=false,prior=12.0:1000G_omni2.5.hg38.sites.vcf.gz \
   --resource 1000G,known=false,training=true,truth=false,prior=10.0:1000G_phase1.snps.high_confidence.hg38.vcf.gz \
   --resource dbsnp,known=true,training=false,truth=false,prior=2.0:Homo_sapiens_assembly38.dbsnp138.vcf.gz \
   -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR \
   -mode SNP \
   -O ${DIR}/output.recal \
   --tranches-file ${DIR}/output.tranches \
   --rscript-file ${DIR}/output.plots.R

#choose the VQSLOD cutoff to filter VCF file
gatk --java-options "-Xms20G -Xmx20G -XX:ParallelGCThreads=2" ApplyVQSR \
  -V ${DIR}/genotyped.g.vcf.gz \
  --recal-file ${DIR}/output.recal \
  -mode SNP \
  --tranches-file ${DIR}/output.tranches \
  --truth-sensitivity-filter-level 99.9 \
  --create-output-variant-index true \
  -O ${DIR}/SNP.recalibrated_99.9.vcf.gz
