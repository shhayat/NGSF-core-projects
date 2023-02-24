#!/bin/bash
#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=bcf-call
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=10:00:00
#SBATCH --mem=6G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

#loading required modules
module load StdEnv/2020
module load gcc/9.3.0
module load bcftools/1.13

REF='/datastore/NGSF001/analysis/references/human/gencode-30/GRCh38.primary_assembly.genome.fa'
INPUT_DIR='${HOME}/projects/20-1LICH-001/mutect2-pipeline/'
INTERVALS='/datastore/NGSF001/analysis/references/human/hg38/agilent_sureselect_human_all_exon_v8_hg38/S33266340_Covered.noheader.noAlt.bed'
PREP1=$1
PREP2=$2

mkdir -p ${HOME}/projects/20-1LICH-001/mutect2-pipeline/bcf_mpileup
#echo ${INPUT_DIR}/merged_bam/${PREP1}_${PREP2}_merged.bam >> ${PREP1}_${PREP2}.txt

bcftools mpileup -Oz -f ${REF} ${HOME}/projects/20-1LICH-001/mutect2-pipeline/merged_bam/${PREP1}_${PREP2}_merged.bam -o ${HOME}/projects/20-1LICH-001/mutect2-pipeline/bcf_mpileup/${PREP1}_${PREP2}_mpileup.vcf.gz
bcftools index -t ${HOME}/projects/20-1LICH-001/mutect2-pipeline/bcf_mpileup/${PREP1}_${PREP2}_mpileup.vcf.gz

#bcftools call -mv -R ${INTERVALS} -f GQ -Oz -o ${HOME}/projects/20-1LICH-001/mutect2-pipeline/bcf_call/${PREP1}_${PREP2}.vcf.gz
#bcftools index -t ${HOME}/projects/20-1LICH-001/mutect2-pipeline/bcf_call/${PREP1}_${PREP2}.vcf.gz
#https://speciationgenomics.github.io/filtering_vcfs/
