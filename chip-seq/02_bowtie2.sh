#!/bin/bash

#SBATCH --job-name=bowtie2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

set -eux

module load samtools
cd /globalhome/hxo752/HPC/tools/bowtie2-2.4.5-linux-x86_64

RAW_DATA=
GENOME=
NCPU=1

mkdir -p ${OUTDIR}
sample_name=$1; shift
fq1=$1; shift
fq2=$1


./bowtie2\
--phred33 \
--mm \
--very-sensitive \
--threads  ${NCPU} \
-x ${GENOME}/index \
-q <input fastq> \
2> \
<bowtie2.log> \
| samtools view -h -b - > <aligned.bam>
#https://www.hdsu.org/chipatac2020/

