#!/bin/bash

#SBATCH --job-name=Gen2Epi
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=48:00:00
#SBATCH --mem=40G
#SBATCH  --output=%j.out

source /globalhome/hxo752/HPC/.bashrc

module load perl/5.36.1
module load python/3.10.13
module load fastqc/0.12.1
module load trimmomatic/0.39
module load bowtie2/2.5.2
module load blast/2.2.26  
module load prodigal/2.6.3
module load bbmap/39.06  

NCPU=4
Gen2Epi_Scripts=/globalhome/hxo752/HPC/tools/Gen2Epi/Gen2Epi_Scripts

#create sample sheet for fastq files
perl Prepare_Input.pl <path-to-fastq-files> <number e.g 12>



