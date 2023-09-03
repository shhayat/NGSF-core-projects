#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=markdup_add_RG
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=4:00:00
#SBATCH --mem=40G
#SBATCH  --output=variantcalling.out

gatk --java-options "-Djava.io.tmpdir=/lscratch/$SLURM_JOBID -Xms2G -Xmx2G -XX:ParallelGCThreads=2" ApplyBQSR \
  -I ${DIR}/${sample_name}/${BAM_FILE} \
  -R ${REF} \
  --bqsr-recal-file ${OUTDIR}/${sample_name}/${sample_name}_recal_data.table \
  -O ${OUTDIR}/${sample_name}/${sample_name}_bqsr.bam
  
gatk --java-options "-Djava.io.tmpdir=/lscratch/$SLURM_JOBID -Xms20G -Xmx20G -XX:ParallelGCThreads=2" HaplotypeCaller \
  -R ${REF} \
  -I ${OUTDIR}/${sample_name}/${sample_name}_bqsr.bam \
  -O ${OUTDIR}/${sample_name}/${sample_name}.vcf.gz \
  -ERC GVCF
