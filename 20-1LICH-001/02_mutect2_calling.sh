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
INPUT_DIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis"
INTERVALS='/datastore/NGSF001/analysis/references/human/hg38/agilent_sureselect_human_all_exon_v8_hg38/S33266340_Covered.noheader.noAlt.bed'
OUTDIR='/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/'
mkdir -p ${OUTDIR}


#Run Mutect2 in tumor only mode (https://gatk.broadinstitute.org/hc/en-us/articles/360035531132--How-to-Call-somatic-mutations-using-GATK4-Mutect2
#https://gatk.broadinstitute.org/hc/en-us/articles/360037593851-Mutect2)
#Run Mutect2 on induced and uninduced samples to generate VCFs
gatk Mutect2 \
     -R ${REF} \
     -I ${INPUT_DIR}/${OUTDIR_NAME}/${OUTDIR_NAME}_mdup_rg.bam \
     -L ${INTERVALS} \
     -O ${INPUT_DIR}/${OUTDIR_NAME}/${OUTDIR_NAME}.vcf.gz
#https://gatk.broadinstitute.org/hc/en-us/articles/360035531132--How-to-Call-somatic-mutations-using-GATK4-Mutect2
