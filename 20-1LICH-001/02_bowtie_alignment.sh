#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=bowtie2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=6:00:00
#SBATCH --mem=80G
#SBATCH  --output=%j.out

set -eux

module load samtools
module load bowtie2/2.5.1

GENOME=/datastore/NGSF001/analysis/indices/human/GRCh38_Bowtie2_build
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/alignment
NCPU=8

sample_name=$1; shift
fq1=$1; shift
fq2=$1

mkdir -p ${OUTDIR}/${sample_name}

gunzip -c ${fq1} | bowtie2 \
--phred33 \
--mm \
--very-sensitive \
--threads ${NCPU} \
-x ${GENOME} \
-1 - \
-2 <(gunzip -c ${fq2}) \
-S ${OUTDIR}/${sample_name}/${sample_name}.sam 2> ${OUTDIR}/${sample_name}/${sample_name}_bowtie2.log \
&& samtools view -h -b ${OUTDIR}/${sample_name}/${sample_name}.sam > ${OUTDIR}/${sample_name}/${sample_name}.aligned.bam

module unload samtools
module unload bowtie2/2.5.1
