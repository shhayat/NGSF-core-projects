#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=concat_preps
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=20G

set -eux

fastq_file="/datastore/APOBECMiSeq/NGS Core Files/NGS Core 2020-1LICH-001/fastq"
output="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/concatenated_fastq"

mkdir -p $output

CLONE_ID=$1; shift
SAMPLE_PREP1=$2; shift
SAMPLE_PREP2=$3; shift
CONDITION=$4;

cat $fastq_file/$SAMPLE_PREP1*R1_001.fastq.gz $fastq_file/$SAMPLE_PREP2*R1_001.fastq.gz >> $output/${CLONE_ID}_${CONDITION}_R1.fastq.gz
cat $fastq_file/$SAMPLE_PREP1*R2_001.fastq.gz $fastq_file/$SAMPLE_PREP2*R2_001.fastq.gz >> $output/${CLONE_ID}_${CONDITION}_R2.fastq.gz
