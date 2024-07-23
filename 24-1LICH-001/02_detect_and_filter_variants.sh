#!/bin/bash

#SBATCH --job-name=star-align
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=48:00:00
#SBATCH --mem=40G
#SBATCH  --output=%j.out
set -eux

#this analysis pipeline is implemented using https://github.com/wang-lab/IMAPR
#loading required modules
module load python/3.11.5
module load perl/5.36.1

IMAPR=/globalhome/hxo752/HPC/tools/IMAPR
tools=/globalhome/hxo752/HPC/tools/IMAPR/tools
reference=/globalhome/hxo752/HPC/tools/IMAPR/reference
out_folder=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/24-1LICH-001/analysis/detect_variants
gatk=$tools/gatk-4.1.8.1/gatk
picard=$tools/picard.jar
hisat2=$tools/hisat2-2.1.0/hisat2
samtools=$tools/samtools-1.10/samtools
bcftools=$tools/bcftools-1.10.2/bcftools
fasta_ref=$reference/GRCh38.d1.vd1.fa
gtf_ref=$reference/gencode.v36.annotation.gtf
hisat_ref=$reference/hisat2_GRCh38
igg_ref=$reference/IGG.gtf
hla_ref=$reference/HLA.gtf
pseudo_ref=$reference/pseudoGene.gtf
radar_ref=$reference/Radar_38.bed
darned_ref=$reference/Darned_38.bed
REDI_ref=$reference/RNA-EDI_38.bed
dbsnp_ref=$reference/common_all_20180418.vcf.gz
germline_ref=$reference/af-only-gnomad.hg38.vcf.gz 
PON_ref=$reference/1000g_pon.hg38.vcf.gz
genelist_ref=$reference/gg.list
tcga_PON_ref=$reference/MuTect2.PON.5210.vcf.tar


mkdir -p $out_folder
unindued=$1; shift
induced=$1; shift
sample_name=$1;

perl ${IMAPR}/detect_variants.pl \
            -ID $sample_name -mode RNA/RNA -T $induced -N $unindued -O $out_folder \
            -thread 4 -ram 40GB \
            -gatk $gatk -picard $picard -hisat2 $hisat2 -samtools $samtools \ 
            -R $fasta_ref -gtf $gtf_ref -gene $genelist_ref -dbsnp $dbsnp_ref -hisat2_reference $hisat_ref -germline $germline_ref -pon $PON_ref


#.bashrc was added because one of the perl module for filter_variants.pl was not installed and it was manually installed under local perl directory
source /globalhome/hxo752/HPC/.bashrc

perl ${IMAPR}/filter_variants.pl \
                -ID $sample_name \
                -O $out_folder \
                -R $fasta_ref \
                -igg $igg_ref \
                -hla $hla_ref \
                -pseudo $pseudo_ref \
                -tcga $tcga_PON_ref \
                -radar $radar_ref \
                -darned $darned_ref \
                -redi $REDI_ref \
                -samtools $samtools \
                -bcftools $bcftools



perl ${IMAPR}/machine_learning.pl \
                -ID $sample_name \
                -O $out_folder \
                -gtf $gtf_ref
