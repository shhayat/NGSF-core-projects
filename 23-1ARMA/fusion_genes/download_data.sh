#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=download_data
#SBATCH --cpus-per-task=2
#SBATCH --mem=40G
#SBATCH --time=2:00:00
#SBATCH --output=%j.out

NUM=$1; shift
SRR=$1;

wget https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR176/${NUM}/${SRR}/${SRR}_1.fastq.gz
wget https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR176/${NUM}/${SRR}/${SRR}_2.fastq.gz

