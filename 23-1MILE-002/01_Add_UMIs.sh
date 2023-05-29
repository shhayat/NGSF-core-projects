#!/bin/bash

#SBATCH --job-name=umi_tools
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=4G

fastq=/datastore/NGSF001/projects/23-1MILE-002/fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002/analysis/fq_with_umi_header
mkdir -p ${OUTDIR}

sample_name=$1; shift
fq1=$1; shift
fq2=$1;

#Add UMIs to header of Fastq R1 and R2 file
umi_tools extract -p NNNNNNNNNNN -I ${fq1} -S ${OUTDIR}/${sample_name}_R1.fastq.gz --read2-in=${fq2} --read2-out=${OUTDIR}/${sample_name}_R2.fastq.gz 
