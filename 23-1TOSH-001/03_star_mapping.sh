#!/bin/bash

#SBATCH --job-name=star-align
#SBATCH --constraint=skylake
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=3:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

#loading required modules
module load star/2.7.9a 
module load samtools

GENOME=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001/analysis/indices/star-index
OUTDATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1TOSH-001/analysis/star_alignment

sample_name=$1; shift
fq1=$1; shift
fq2=$1;

mkdir -p ${OUTDATA}/${sample_name}
cd ${OUTDATA}/${sample_name}

STAR --genomeDir $GENOME \
	--readFilesCommand zcat \
	--readFilesIn ${fq1} ${fq2} \
	--outSAMstrandField intronMotif \
	--outSAMtype BAM SortedByCoordinate \
	--outFilterIntronMotifs RemoveNoncanonical \
	--sjdbGTFfeatureExon exon \
	--runThreadN 4 \
	&& samtools index Aligned.sortedByCoord.out.bam

