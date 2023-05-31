#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=sra_download
#SBATCH --cpus-per-task=1
#SBATCH --mem=100G
#SBATCH --time=24:00:00
#SBATCH --output=%j.out


for i in {4369..4389}
do
  wget https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR176/069/SRR17624369/SRR17624369_1.fastq.gz
  wget https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR176/069/SRR17624369/SRR17624369_2.fastq.gz

