#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=varaint_calling
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=4:00:00
#SBATCH --mem=20G
#SBATCH  --output=%j_variantcalling.out

#https://hpc.nih.gov/training/gatk_tutorial/haplotype-caller.html

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/variants
mkdir -p ${OUTDIR}

gatk --java-options "-Xms20G -Xmx20G -XX:ParallelGCThreads=2" HaplotypeCaller \
  -R ${REF} \
  -I ${DIR}/${sample_name}/${sample_name}_bqsr.bam \
  -O ${OUTDIR}/${sample_name}.vcf.gz
