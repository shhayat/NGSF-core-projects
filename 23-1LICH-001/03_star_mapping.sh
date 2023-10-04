#!/bin/bash

#SBATCH --job-name=star-align
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=1:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

#loading required modules
module load star/2.7.9a 
module load samtools

GENOME=/datastore/NGSF001/analysis/indices/human/gencode-40
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001/analysis/star_alignment
NCPU=4

mkdir -p ${OUTDIR}

sample_name=$1; shift
fq1=$1; shift
fq2=$1

mkdir -p ${OUTDIR}/${sample_name} && cd ${OUTDIR}/${sample_name}

STAR --genomeDir $GENOME \
	--readFilesCommand zcat \
	--readFilesIn ${fq1} ${fq2} \
	--outSAMtype BAM SortedByCoordinate \
	--runThreadN ${NCPU} \
	&& samtools index Aligned.sortedByCoord.out.bam 
