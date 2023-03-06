#!/bin/bash
#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=bcftools-filter
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:20:00
#SBATCH --mem=2G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

set -eux

##loading required modules
module load bedtools

INPUT_DIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/concatenated_samples_per_protein"
OUTPUT_DIR='/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/filtered_vcfs'
GENOME='/datastore/NGSF001/analysis/references/human/gencode-30/GRCh38.primary_assembly.genome.fa'
mkdir -p ${OUTPUT_DIR}

CLONE_ID=$1
COND=$2
 

gunzip -k ${INPUT_DIR}/${CLONE_ID}_${COND}_concat.vcf.gz

#Extract bases C converting. to T or G base
grep -P 'C\tG' ${INPUT_DIR}/${CLONE_ID}_${COND}_concat.vcf >> ${OUTPUT_DIR}/${CLONE_ID}_${COND}_concat_filtered.vcf
grep -P 'C\tT' ${INPUT_DIR}/${CLONE_ID}_${COND}_concat.vcf >> ${OUTPUT_DIR}/${CLONE_ID}_${COND}_concat_filtered.vcf
grep -P 'C\tTG' ${INPUT_DIR}/${CLONE_ID}_${COND}_concat.vcf >> ${OUTPUT_DIR}/${CLONE_ID}_${COND}_concat_filtered.vcf
grep -P 'C\tGT' ${INPUT_DIR}/${CLONE_ID}_${COND}_concat.vcf >> ${OUTPUT_DIR}/${CLONE_ID}_${COND}_concat_filtered.vcf

awk -v OFS='\t' '{print $5, $1}'

#step1: Convert vcf to bed file
/globalhome/hxo752/HPC/tools/bedops/convert2bed -i vcf < MCF7_A3H_I_concat.vcf -d >  MCF7_A3H_I_concat.bed

#step2: Extract C to T conversions and select first 3 columns (chrom, start, end position)
grep -P '\tC\tT' MCF7_A3H_I_concat.bed | awk -v OFS='\t' '{print $1,$2,$3}' > c_to_t.bed
#bedtools intersect -a MCF7_A3H_I_concat.bed -b MCF7_A3H_I_concat.bed -wa -wb | awk '$6=="C" && $7=="T"' > c_to_t.bed

#step3:
bedtools flank -i c_to_t.bed -g /datastore/NGSF001/analysis/references/human/gencode-30/chrom.sizes -b 1 > c_to_t_flanked_up_down_2bp.bed

#step4
bedtools getfasta -fi /datastore/NGSF001/analysis/references/human/gencode-30/GRCh38.primary_assembly.genome.fa -bed c_to_t_flanked_up_down_2bp.bed -fo c_to_t_flanked_up_down_2bp.fasta



#bedtools flank -i c_to_t_flanked.vcf -g /datastore/NGSF001/analysis/references/human/gencode-30/chrom.sizes -b 2 > c_to_t_flanked_2bp.vcf










gunzip -k ${INPUT_DIR}/${CLONE_ID}_${COND}_concat.vcf.gz
#bedtools flank -i MCF7_A3B_U_concat.vcf -g chrom.sizes -b 2 > test.vcf

bedtools intersect -a MCF7_A3H_I_concat.vcf -b MCF7_A3H_I_concat.vcf -wa -wb | awk '$4=="C" && $5=="T"' > c_to_t_flanked.vcf

#bedtools flank -i c_to_t_flanked.vcf -g /datastore/NGSF001/analysis/references/human/gencode-30/chrom.sizes -b 2 > c_to_t_flanked_2bp.vcf



First, you'll need to convert your VCF file to a BED file using the vcf2bed utility from bedtools:
lua
Copy code
vcf2bed < input.vcf > output.bed
This will create a BED file containing the genomic coordinates of each variant in the VCF file.

Next, you can use the bedtools flank command to add flanking regions to each variant in the BED file:
css
Copy code
bedtools flank -i output.bed -g genome_file.txt -l 1 -r 1 > output_flanked.bed
Here's a breakdown of the options used:

-i output.bed specifies the input BED file
-g genome_file.txt specifies a file containing the sizes of each chromosome in the genome
-l 1 -r 1 specifies that we want to add 1 base of flanking sequence to each side of the variant.
This will create a new BED file called output_flanked.bed, which contains the original genomic coordinates of each variant, as well as one base of flanking sequence on either side.

Finally, you can use the bedtools intersect command to find all C to T conversions and their flanking bases. This command will intersect the flanked BED file with itself, keeping only variants where the reference allele is 'C' and the alternate allele is 'T':
swift
Copy code
bedtools intersect -a output_flanked.bed -b output_flanked.bed -wa -wb | awk '$5=="C" && $10=="T"' > c_to_t_flanked.bed
Here's a breakdown of the options used:

-a output_flanked.bed -b output_flanked.bed specifies that we want to intersect the flanked BED file with itself
-wa -wb specifies that we want to output both the A and B entries (i.e. the two intersecting intervals) for each overlap
-f 1 -r specifies that we want to require a complete overlap between the two intervals (i.e. the entire variant) and that the overlap must be on the same strand
-v -e -i specifies that we want to exclude variants that don't overlap with themselves (i.e. no single-base variants) and that we want to ignore any overlaps within the same interval (i.e. ignore self-overlaps)
awk '$5=="C" && $10=="T"' filters the output to only include variants where the reference allele is 'C' and the alternate allele is 'T', and saves the output to a new BED file called c_to_t_flanked.bed.
The resulting c_to_t_flanked.bed file will contain the genomic coordinates of all C to T conversions in the original VCF file, as well as one base of flanking sequence on either side.







