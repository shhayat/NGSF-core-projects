#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=gatk-mutect2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=2:00:00
#SBATCH --mem=6G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

#loading required modules
module load gatk/4.2.2.0

#reference file
REF='/datastore/NGSF001/analysis/references/human/gencode-30/GRCh38.primary_assembly.genome.fa'
PROJECT_ID='20-1LICH-001'
INPUT_DIR="${HOME}/projects/${PROJECT_ID}/mutect2-pipeline/merged_bam"
INTERVALS='/datastore/NGSF001/analysis/references/human/hg38/agilent_sureselect_human_all_exon_v8_hg38/S33266340_Covered.noheader.noAlt.bed'
PREP1=$1
PREP2=$2
mkdir -p ${HOME}/projects/${PROJECT_ID}/mutect2-pipeline/mutect2_calling

#Run Mutect2 in tumor only mode (https://gatk.broadinstitute.org/hc/en-us/articles/360035531132--How-to-Call-somatic-mutations-using-GATK4-Mutect2
#https://gatk.broadinstitute.org/hc/en-us/articles/360037593851-Mutect2)
#Run Mutect2 on induced and uninduced samples to generate VCFs
gatk Mutect2 \
     -R ${REF} \
     -I ${INPUT_DIR}/${PREP1}_${PREP2}_merged.bam  \
     -L ${INTERVALS} \
     -O ${HOME}/projects/${PROJECT_ID}/mutect2-pipeline/mutect2_calling/${PREP1}_${PREP2}.vcf.gz
