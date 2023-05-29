#!/bin/bash

#SBATCH --job-name=umi_tools
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=4G

#Add UMIs to header of Fastq R1 and R2 file
umi_tools extract -p NNNNNNNNNNN \ 
                  -I IN_FASTQ.gz \
                  -S OUT_FASTQ.gz \
                  --read2-in=IN2_FASTQ.gz \
                  --read2-out=OUT2_FASTQ.gz
