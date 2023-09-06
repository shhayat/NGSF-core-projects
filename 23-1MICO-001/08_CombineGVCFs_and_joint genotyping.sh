#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=CombineGVCFs_jointGenotyping
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --mem=10G
#SBATCH  --output=%j_CombineGVCFs_jointGenotyping.out

 DIR=
 REF=
 
 gatk --java-options "-Xms10G -Xmx10G -XX:ParallelGCThreads=2" CombineGVCFs \
   -R reference.fasta \
   --variant /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/variants/D23000043.g.vcf.gz \
   --variant /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/variants/D23000044.g.vcf.gz \
   -O combine.g.vcf.gz

gatk --java-options "-Xms10G -Xmx10G -XX:ParallelGCThreads=2" GenotypeGVCFs \
  -R ${REF} \
  -V  ${OUTDIR}/combine.g.vcf.gz -O ${OUTDIR}/genotyped.g.vcf.gz
