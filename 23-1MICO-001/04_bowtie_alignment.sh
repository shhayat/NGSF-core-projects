#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=bowtie2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=4:00:00
#SBATCH --mem=20G
#SBATCH  --output=%j.out

set -eux

module load samtools
module load bowtie2/2.5.1

RAW_DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/Fastq
GENOME=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/indices/bowtie_index
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis
NCPU=4

sample_name=$1; shift
fq1=$1; shift
fq2=$1

mkdir -p ${OUTDIR}/alignment/${sample_name}

gunzip -c ${RAW_DATA}/${fq1} bowtie2 \
--phred33 \
--mm \
--very-sensitive \
--threads ${NCPU} \
-x ${GENOME} \
-1 - \
-2 <(gunzip -c ${RAW_DATA}/${fq2}) \
-S ${OUTDIR}/alignment/${sample_name}/${sample_name}.sam 2> ${OUTDIR}/alignment/${sample_name}/${sample_name}_bowtie2.log \
&& samtools view -h -b ${OUTDIR}/alignment/${sample_name}/${sample_name}.sam > ${OUTDIR}/alignment/${sample_name}/${sample_name}.aligned.bam

module unload samtools
module unload bowtie2/2.5.1
