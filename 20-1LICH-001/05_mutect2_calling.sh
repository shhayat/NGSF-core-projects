#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=gatk-mutect2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=5:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

#loading required modules
module load StdEnv/2020
module load gatk/4.2.2.0

#reference file
REF='/datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa'
INPUT_DIR="/project/anderson/alignment/"
INTERVALS='/datastore/NGSF001/analysis/references/human/hg38/agilent_sureselect_human_all_exon_v8_hg38/S33266340_Covered.noheader.noAlt.bed'
OUTDIR='/project/anderson/'
mkdir -p ${OUTDIR}

sample_name=$1;

#Run Mutect2 in tumor only mode (https://gatk.broadinstitute.org/hc/en-us/articles/360035531132--How-to-Call-somatic-mutations-using-GATK4-Mutect2
#https://gatk.broadinstitute.org/hc/en-us/articles/360037593851-Mutect2)
#Run Mutect2 on induced and uninduced samples to generate VCFs
gatk Mutect2 \
     -R ${REF} \
     -I ${INPUT_DIR}/${sample_name}/${sample_name}_bqsr.bam \
     -L ${INTERVALS} \
     -O ${INPUT_DIR}/${sample_name}/${sample_name}.vcf.gz
#https://gatk.broadinstitute.org/hc/en-us/articles/360035531132--How-to-Call-somatic-mutations-using-GATK4-Mutect2
