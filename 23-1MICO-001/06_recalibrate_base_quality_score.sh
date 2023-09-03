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

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/alignment
REF=
sample_name=1; shift
BAM_FILE=1;

gatk --java-options "-Djava.io.tmpdir=/lscratch/$SLURM_JOBID -Xms4G -Xmx4G -XX:ParallelGCThreads=2" BaseRecalibrator \
  -I ${DIR}/${sample_name}/${BAM_FILE} \
  -R /fdb/igenomes/Homo_sapiens/UCSC/hg38/Sequence/WholeGenomeFasta/genome.fa \
  -O ${OUTDIR}/${sample_name}/${sample_name}_recal_data.table \
  --known-sites /fdb/GATK_resource_bundle/hg38/dbsnp_146.hg38.vcf.gz \
  --known-sites /fdb/GATK_resource_bundle/hg38/Homo_sapiens_assembly38.known_indels.vcf.gz \
  --known-sites /fdb/GATK_resource_bundle/hg38/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz


gatk BaseRecalibrator \
   -I ${DIR}/${sample_name}/${BAM_FILE} \
   -R reference.fasta \
   --known-sites sites_of_variation.vcf \
   --known-sites another/optional/setOfSitesToMask.vcf \
   -O ${OUTDIR}/${sample_name}/${sample_name}_recal_data.table

  gatk --java-options "-Djava.io.tmpdir=/lscratch/$SLURM_JOBID -Xms2G -Xmx2G -XX:ParallelGCThreads=2" ApplyBQSR \
  -I ${DIR}/${sample_name}/${BAM_FILE} \
  -R /fdb/igenomes/Homo_sapiens/UCSC/hg38/Sequence/WholeGenomeFasta/genome.fa \
  --bqsr-recal-file ${OUTDIR}/${sample_name}/${sample_name}_recal_data.table \
  -O NA12891_markdup_bqsr.bam
