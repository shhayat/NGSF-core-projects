#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=varaint_calling
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=4:00:00
#SBATCH --mem=20G
#SBATCH  --output=variantcalling.out
#https://hpc.nih.gov/training/gatk_tutorial/haplotype-caller.html
  
gatk --java-options "-Xms20G -Xmx20G -XX:ParallelGCThreads=2" HaplotypeCaller \
  -R ${REF} \
  -I ${OUTDIR}/${sample_name}/${sample_name}_bqsr.bam \
  -O ${OUTDIR}/${sample_name}/${sample_name}.vcf.gz \
  -ERC GVCF
