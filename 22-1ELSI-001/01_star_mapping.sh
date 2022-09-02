#!/bin/bash

#SBATCH --job-name=star-align
#SBATCH --constraint=skylake
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --time=1:00:00
#SBATCH --mem=80G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

set -eux

#loading required modules
module load star/2.7.9a 
module load samtools

DATA=/datastore/NGSF001/projects/22-1ELSI-001/analysis/fastq/fastq
GENOME=/datastore/NGSF001/analysis/indices/horse/index/star-2.7.9a
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1ELSI-001/analysis/star_alignment
GTF=
NCPU=10

mkdir -p ${OUTDIR}
sample_name=$1; shift
fq1=$1; shift
fq2=$1

mkdir -p ${OUTDIR}/${sample_name} && cd ${OUTDIR}/${sample_name}

STAR --genomeDir $GENOME \
	--readFilesCommand zcat \
	--readFilesIn ${fq1} ${fq2} \
	--outSAMstrandField intronMotif \
	--outSAMtype BAM SortedByCoordinate \
	--outFilterIntronMotifs RemoveNoncanonical \
	--sjdbGTFfile ${GTF} \
	--runThreadN ${NCPU} \
	&& samtools index Aligned.sortedByCoord.out.bam
