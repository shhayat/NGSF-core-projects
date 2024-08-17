#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=alignment
#SBATCH --ntasks=1
#BATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=5G
#SBATCH --output=/project/anderson/%j.out

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
fastq_file_path=/project/anderson/trimmed_fastq

#create sample sheet for fastq files
perl ${Gen2Epi_Scripts}/Prepare_Input.pl ${fastq_file_path} 179

#read mapping
#perl ${Gen2Epi_Scripts}/ReadMapping.pl 


