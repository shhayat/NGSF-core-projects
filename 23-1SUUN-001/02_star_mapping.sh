#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=star-align
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=3:00:00
#SBATCH --mem=60G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

#loading required modules
module load star/2.7.9a 
module load samtools


DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SUUN-001/fastq
GENOME=/datastore/NGSF001/projects/23-1MILE-001/Analysis/indices/star-index
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SUUN-001/analysis/star_alignment
NCPU=4

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
	
