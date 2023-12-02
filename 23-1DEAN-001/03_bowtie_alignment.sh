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
cd /globalhome/hxo752/HPC/tools/bowtie2-2.4.5-linux-x86_64

#RAW_DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/fastq
#GENOME=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/indices/bowtie_index
RAW_DATA=/datastore/NGSF001/projects/23-1DEAN-001/analysis/fastq
GENOME=/datastore/NGSF001/projects/23-1DEAN-001/analysis/indices/indices/bowtie_index
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis
NCPU=4

sample_name=$1; shift
fq=$1

mkdir -p ${OUTDIR}/alignment/${sample_name}

bowtie2 \
--phred33 \
--mm \
--very-sensitive \
--threads ${NCPU} \
-x ${GENOME} \
-U ${RAW_DATA}/${fq} \
-S ${OUTDIR}/alignment/${sample_name}/${sample_name}.sam 2> ${OUTDIR}/alignment/${sample_name}/${sample_name}_bowtie2.log \
&& samtools view -h -b ${OUTDIR}/alignment/${sample_name}/${sample_name}.sam > ${OUTDIR}/alignment/${sample_name}/${sample_name}.aligned.bam

module unload samtools
