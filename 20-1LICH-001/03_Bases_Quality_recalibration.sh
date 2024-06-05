#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=recalibrate
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=4:00:00
#SBATCH --mem=10G
#SBATCH  --output=%j_recalibrate.out

module load gatk/4.2.5.0 

#DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/alignment
REF=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/genome/genome.fa
gatk_resource=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/gatk_resource_bundle
sample_name=$1; shift
BAM_FILE=$1;

gatk --java-options "-Xms10G -Xmx10G -XX:ParallelGCThreads=2" BaseRecalibrator \
  -I ${BAM_FILE} \
  -R ${REF} \
  -O ${OUTDIR}/${sample_name}/${sample_name}_recal_data.table \
  --known-sites ${gatk_resource}/Homo_sapiens_assembly38.dbsnp138.vcf \
  --known-sites ${gatk_resource}/1000G_phase1.snps.high_confidence.hg38.vcf.gz

gatk --java-options "-Xms10G -Xmx10G -XX:ParallelGCThreads=2" ApplyBQSR \
  -I ${BAM_FILE} \
  -R ${REF} \
  --bqsr-recal-file ${OUTDIR}/${sample_name}/${sample_name}_recal_data.table \
  -O ${OUTDIR}/${sample_name}/${sample_name}_bqsr.bam




Recalibration Base quality score step should be run before calling mutect2. This was part of pre processing step which was missed in this project

#https://console.cloud.google.com/storage/browser/gcp-public-data--broad-references/hg38/v0?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22))&prefix=&forceOnObjectsSortingFiltering=false
java -jar GenomeAnalysisTK.jar \ 
    -T BaseRecalibrator \ 
    -R reference.fa \ 
    -I input_reads.bam \ 
    -L 20 \ 
    -knownSites dbsnp.vcf \ 
    -knownSites gold_indels.vcf \ 
    -o recal_data.table 
    
    java -jar GenomeAnalysisTK.jar \ 
    -T BaseRecalibrator \ 
    -R reference.fa \ 
    -I realigned_reads.bam \ 
    -L 20 \ 
    -knownSites dbsnp.vcf \ 
    -knownSites gold_indels.vcf \ 
    -BQSR recal_data.table \ 
    -o post_recal_data.table 



check this https://learn.gencore.bio.nyu.edu/variant-calling/pre-processing/
