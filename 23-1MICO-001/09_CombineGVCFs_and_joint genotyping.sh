#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=CombineGVCFs_jointGenotyping
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=4:00:00
#SBATCH --mem=20G
#SBATCH  --output=%j_variant_quality.out

 REF=
 
 gatk --java-options "-Xms20G -Xmx20G -XX:ParallelGCThreads=2" CombineGVCFs \
   -R reference.fasta \
   --variant sample1.g.vcf.gz \
   --variant sample2.g.vcf.gz \
   -O combine.g.vcf.gz

gatk --java-options "-Xms20G -Xmx20G -XX:ParallelGCThreads=2" GenotypeGVCFs \
  -R ${REF} \
  -V  ${OUTDIR}/${sample_name}.g.vcf.gz -O ${OUTDIR}/
