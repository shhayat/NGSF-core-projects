#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=trim
#SBATCH --ntasks=1
#BATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mem=5G
#SBATCH --output=/project/anderson/%j.out

#module purge
#module load python/3.10
#module load StdEnv/2020
#module load scipy-stack/2023a
#module load fastp/0.23.4

#OUTDIR=/project/anderson/trimmed_fastq

#NCPU=1

#sample_name=$1; shift
#fq1=$1; shift
#fq2=$1;

#mkdir -p ${OUTDIR}

 #fastp -i ${fq1} \
 #      -I ${fq2} \
 ##      -o ${OUTDIR}/${sample_name}_R1.fastq.gz \
 #      -O ${OUTDIR}/${sample_name}_R2.fastq.gz \
 #      -h ${OUTDIR}/${sample_name}.fastp.html \
 #      --thread $NCPU \
 #      --length_required 100 \
 #      --average_qual 20 \
 #      --trim_poly_x \
 #      --trim_poly_g \
 #      --detect_adapter_for_pe
 
source /globalhome/hxo752/HPC/.bashrc

module load perl/5.36.1
module load python/3.10.13
module load fastqc/0.12.1
module load trimmomatic/0.39
module load bowtie2/2.5.2
module load blast/2.2.26  
module load prodigal/2.6.3
module load bbmap/39.06  

NCPU=30
Gen2Epi_Scripts=/globalhome/hxo752/HPC/tools/Gen2Epi/Gen2Epi_Scripts
FASTQ_DIR=/project/anderson/TB_DATA/PHO
OUTDIR=/project/anderson/trimmed
mkdir -p $OUTDIR
cd $OUTDIR
#create sample sheet for fastq files
perl ${Gen2Epi_Scripts}/Prepare_Input.pl ${FASTQ_DIR} 109

#quality check and trimming
perl ${Gen2Epi_Scripts}/WGS_SIBP_P1.pl /project/anderson/Prepare_Input.txt /project/anderson/TB_DATA/PHO both 3 3 4:15 30

