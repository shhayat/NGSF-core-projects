#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=alignment
#SBATCH --ntasks=1
#BATCH --cpus-per-task=6
#SBATCH --time=10:00:00
#SBATCH --mem=5G
#SBATCH --output=/project/anderson/%j.out

source /globalhome/hxo752/HPC/.bashrc

#module load perl/5.36.1
#module load python/3.11.5
#module load fastqc/0.12.1
#module load trimmomatic/0.39
module load bowtie2/2.5.2
#module load blast/2.2.26  
#module load prodigal/2.6.3
#module load bbmap/39.06  
module load samtools

sample_name=$1; shift
fq1=$1;shift
fq2=$1;

NCPU=6
#Gen2Epi_Scripts=/globalhome/hxo752/HPC/tools/Gen2Epi/Gen2Epi_Scripts
fastq_file_path=/project/anderson/trimmed_fastq
index=/project/anderson/index/bowtie_index
OUTDIR=/project/anderson/mapping

mkdir -p ${OUTDIR}

#read mapping
#perl ${Gen2Epi_Scripts}/ReadMapping.pl ${index} ${fastq_file_path} ${OUTDIR}

gunzip -c ${fq1} | bowtie2 \
--threads ${NCPU} \
-x ${index} \
-1 - \
-2 <(gunzip -c ${fq2}) \
-S ${OUTDIR}/${sample_name}.sam 2> ${OUTDIR}/${sample_name}_bowtie2.log \
&& samtools view -h -b ${OUTDIR}/${sample_name}.sam > ${OUTDIR}/${sample_name}.aligned.bam

rm ${OUTDIR}/${sample_name}/${sample_name}.sam

module unload samtools
module unload bowtie2/2.5.2
