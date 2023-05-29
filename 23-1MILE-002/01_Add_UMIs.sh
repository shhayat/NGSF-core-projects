#!/bin/bash

#SBATCH --job-name=umi_tools
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=4G

fastq=/datastore/NGSF001/projects/23-1MILE-002/fastq
fq_with_umi_header=
#Add UMIs to header of Fastq R1 and R2 file
umi_tools extract -p NNNNNNNNNNN \ 
                  -I R2300125_S4_R1_001.fastq.gz \
                  -S R2300125_S4_R1_001.fastq.gz \
                  --read2-in=IN2_FASTQ.gz \
                  --read2-out=OUT2_FASTQ.gz
