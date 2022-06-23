#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=bowtie2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

set -eux

module load samtools
cd /globalhome/hxo752/HPC/tools/bowtie2-2.4.5-linux-x86_64

RAW_DATA=
GENOME=
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis
NCPU=2

mkdir -p ${OUTDIR}/alignment
sample_name=$1; shift
fq=$1


(./bowtie2\
--phred33 \
--mm \
--very-sensitive \
--threads  ${NCPU} \
-x ${GENOME}/index \
-q ${fq} \
-S ${OUTDIR}/${sample_name}/${sample_name}.sam) \
2>> \
${OUTDIR}/alignment/bowtie2.log \
&& samtools view -h -b ${OUTDIR}/${sample_name}/${sample_name}.sam > ${OUTDIR}/${sample_name}/${sample_name}.aligned.bam

#https://www.hdsu.org/chipatac2020/

