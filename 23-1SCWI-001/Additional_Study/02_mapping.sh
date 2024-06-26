#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=star-align
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=%j.out
set -eux

#loading required modules
module load star/2.7.9a 
module load samtools


DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SCWI-001/Additional_Study/fastq_trimmed
GENOME=/datastore/NGSF001/analysis/indices/mouse/star-index-m32gencode
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SCWI-001/Additional_Study/analysis/star_alignment
NCPU=4

sample_name=$1; shift
fq1=$1;

mkdir -p ${OUTDIR}/${sample_name} && cd ${OUTDIR}/${sample_name}

STAR --genomeDir $GENOME \
	--readFilesCommand zcat \
	--readFilesIn ${fq1} \
	--outSAMtype BAM SortedByCoordinate \
	--runThreadN ${NCPU} \
	&& samtools index Aligned.sortedByCoord.out.bam 
