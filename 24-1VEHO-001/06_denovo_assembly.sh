#!/bin/bash

#SBATCH --job-name=Gen2Epi
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=
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

NCPU=
Gen2Epi_Scripts=/globalhome/hxo752/HPC/tools/Gen2Epi/Gen2Epi_Scripts
FASTQ_DIR=/project/anderson/trimmed_fastq
#create sample sheet for fastq files
#perl Prepare_Input.pl ${FASTQ_DIR} 179

#denovo assembly
perl WGS_SIBP_P2.pl /project/anderson/Prepare_Input.txt ${FASTQ_DIR} trimmed

Trimming trimmed 2 --cov-cutoff auto --careful --kmer 21335571 ${NCPU}


