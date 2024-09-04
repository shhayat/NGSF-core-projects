#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=run_repair
#SBATCH --ntasks=1
#BATCH --cpus-per-task=10
#SBATCH --time=20:00:00
#SBATCH --mem=5G
#SBATCH --output=/project/anderson/%j.out

module load bbmap//39.06

sample_name=$1; shift
fq1=$1;shift
fq2=$1;


DATA=/project/anderson/trimmed_fastq
OUTDIR=/project/anderson/trimmed_fastq

mkdir -p $OUTDIR

repair.sh in=${fq1} \
          in2=${fq2} \
          out=${OUTDIR}/{sample_name}_R1_repair.fastq.gz \
          out2=${OUTDIR}/{sample_name}_R2_repair.fastq.gz \
          outs=${OUTDIR}/{sample_name}_singletons.fastq.gz \
          repair=t


module load bowtie2/2.5.2
module load samtools

NCPU=10
index=/project/anderson/index/bowtie_index
OUTDIR=/project/anderson/mapping

mkdir -p ${OUTDIR}

gunzip -c ${OUTDIR}/{sample_name}_R1_repair.fastq.gz | bowtie2 \
--threads ${NCPU} \
-x ${index} \
-1 - \
-2 <(gunzip -c ${OUTDIR}/{sample_name}_R2_repair.fastq.gz) \
-S ${OUTDIR}/${sample_name}.sam 2> ${OUTDIR}/${sample_name}_bowtie2.log \
&& samtools view -h -b ${OUTDIR}/${sample_name}.sam > ${OUTDIR}/${sample_name}.aligned.bam

rm ${OUTDIR}/${sample_name}.sam

module unload samtools
module unload bowtie2/2.5.2
