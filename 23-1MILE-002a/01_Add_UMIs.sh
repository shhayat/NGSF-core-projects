#!/bin/bash

#SBATCH --job-name=umi_tools
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=40G


# This step was added because our orignal files had no UMI information in header of reads due to which when we ran UMI dedup step we got an
# error AssertionError: not all umis are the same length(!):  4 - 5. To fix this error umi_tools extract was used to add UMIs to the header of 
#reads

umitools=/globalhome/hxo752/HPC/.local/bin
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002/analysis/fq_with_umi_header
mkdir -p ${OUTDIR}

sample_name=$1; shift
fq1=$1; shift
fq2=$1;

#Add UMIs to header of Fastq R1
#UMIs are present only in R1 file
${umitools}/umi_tools extract -I ${fq1} \
                  -S ${OUTDIR}/${sample_name}_R1.fastq.gz \
                  --read2-in=${fq2} \
                  --read2-out=${OUTDIR}/${sample_name}_R2.fastq.gz \
                  --bc-pattern=NNNNNNNNNNN \
                  --log=${OUTDIR}/${sample_name}.log
