#!/bin/bash
#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=select_variants
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:20:00
#SBATCH --mem=2G
#SBATCH  --output=%j.out

set -eux

##loading required modules for bedtools

#module load bedtools
module load nixpkgs/16.09 
module load gcc/5.4.0
module load intel/2016.4
module load intel/2017.1
module load bedtools

INPUT_DIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/concatenated_samples_per_protein"
OUTPUT_DIR='/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/filtered_vcfs'
GENOME='/datastore/NGSF001/analysis/references/human/gencode-30/GRCh38.primary_assembly.genome.fa'
mkdir -p ${OUTPUT_DIR}

CLONE_ID=$1
COND=$2
 
gunzip -k ${INPUT_DIR}/${CLONE_ID}_${COND}_concat.vcf.gz

#step1: Convert vcf to bed file
/globalhome/hxo752/HPC/tools/bedops/convert2bed -i vcf < ${INPUT_DIR}/${CLONE_ID}_${COND}_concat.vcf -d >  ${INPUT_DIR}/${CLONE_ID}_${COND}_concat.bed

##step2: Extract C to T or G conversions and select first 3 columns (chrom, start, end position)
grep -P '\tC\tG' ${INPUT_DIR}/${CLONE_ID}_${COND}_concat.bed | awk -v OFS='\t' '{print $1,$2,$3}' >> ${OUTPUT_DIR}/${CLONE_ID}_${COND}_concat_CtoTorG.bed
grep -P '\tC\tT' ${INPUT_DIR}/${CLONE_ID}_${COND}_concat.bed | awk -v OFS='\t' '{print $1,$2,$3}' >> ${OUTPUT_DIR}/${CLONE_ID}_${COND}_concat_CtoTorG.bed
grep -P '\tC\tTG' ${INPUT_DIR}/${CLONE_ID}_${COND}_concat.bed | awk -v OFS='\t' '{print $1,$2,$3}' >> ${OUTPUT_DIR}/${CLONE_ID}_${COND}_concat_CtoTorG.bed
grep -P '\tC\tGT' ${INPUT_DIR}/${CLONE_ID}_${COND}_concat.bed | awk -v OFS='\t' '{print $1,$2,$3}' >> ${OUTPUT_DIR}/${CLONE_ID}_${COND}_concat_CtoTorG.bed

#step3: select 2 bases upstream and downstream of bases in step2
bedtools flank -i ${OUTPUT_DIR}/${CLONE_ID}_${COND}_concat_CtoTorG.bed -g /datastore/NGSF001/analysis/references/human/gencode-30/chrom.sizes -b 2 > ${OUTPUT_DIR}/${CLONE_ID}_${COND}_flanked_2bp_upstream_downstream.bed

#step4: extract flanked bases for file in step3. tab delimited bed file is produced which is written as text file
bedtools getfasta -fi ${GENOME} -bed ${OUTPUT_DIR}/${CLONE_ID}_${COND}_flanked_2bp_upstream_downstream.bed -tab > ${OUTPUT_DIR}/${CLONE_ID}_${COND}_flanked_bases.txt
