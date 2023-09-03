#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=markdup_add_RG
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=4:00:00
#SBATCH --mem=40G
#SBATCH  --output=recalibrate.out

module laod 

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/alignment
REF=/datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa
sample_name=1; shift
BAM_FILE=1;

gatk --java-options "-Djava.io.tmpdir=/lscratch/$SLURM_JOBID -Xms4G -Xmx4G -XX:ParallelGCThreads=2" BaseRecalibrator \
  -I ${DIR}/${sample_name}/${BAM_FILE} \
  -R ${REF} \
  -O ${OUTDIR}/${sample_name}/${sample_name}_recal_data.table \
  --known-sites Homo_sapiens_assembly38.dbsnp138.vcf  \
  --known-sites 1000G_phase1.snps.high_confidence.hg38.vcf.gz

gatk --java-options "-Djava.io.tmpdir=/lscratch/$SLURM_JOBID -Xms2G -Xmx2G -XX:ParallelGCThreads=2" ApplyBQSR \
  -I ${DIR}/${sample_name}/${BAM_FILE} \
  -R ${REF} \
  --bqsr-recal-file ${OUTDIR}/${sample_name}/${sample_name}_recal_data.table \
  -O ${OUTDIR}/${sample_name}/${sample_name}_bqsr.bam
