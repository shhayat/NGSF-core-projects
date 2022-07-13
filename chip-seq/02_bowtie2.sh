#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=bowtie2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=4:00:00
#SBATCH --mem=60G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

set -eux

module load samtools
cd /globalhome/hxo752/HPC/tools/bowtie2-2.4.5-linux-x86_64

RAW_DATA=/datastore/NGSF001/datasets/chipseq_SRA
GENOME=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/indices/HS_GRCh38
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis
NCPU=6

sample_name=$1; shift
fq=$1

mkdir -p ${OUTDIR}/alignment/${sample_name}

./bowtie2 \
--phred33 \
--mm \
--very-sensitive \
--threads ${NCPU} \
-x ${GENOME} \
-q ${RAW_DATA}/${sample_name}/${fq} \
-S ${OUTDIR}/alignment/${sample_name}/${sample_name}.sam 2> ${OUTDIR}/alignment/${sample_name}/${sample_name}_bowtie2.log \
&& samtools view -h -b ${OUTDIR}/alignment/${sample_name}/${sample_name}.sam > ${OUTDIR}/alignment/${sample_name}/${sample_name}.aligned.bam
#https://www.hdsu.org/chipatac2020/


