#!/bin/bash

#SBATCH --job-name=star-align
#SBATCH --constraint=skylake
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=3:00:00
#SBATCH --mem=375G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

#loading required modules
module load star/2.7.9a 
module load samtools

GENOME=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001/analysis/indices/star-index
OUTDATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001/analysis/alignment

sample_name=$1; shift
fq1=$1; shift
fq2=$1;

mkdir -p ${OUTDATA}/${sample_name}
cd ${OUTDATA}/${sample_name}

STAR --genomeDir $GENOME \
	--readFilesCommand zcat \
	--runThreadN 8 \
	--readFilesIn ${fq1} ${fq2} \
	--outFilterType BySJout \
	--outFilterMultimapNmax 20 \
	--alignSJoverhangMin 8 \
	--alignSJDBoverhangMin 1 \
	--outFilterMismatchNmax 999 \
	--outFilterMismatchNoverReadLmax 0.04 \
	--alignIntronMin 20 \
	--alignIntronMax 1000000 \
	--alignMatesGapMax 1000000 \
	--outSAMtype BAM SortedByCoordinate \
	&& samtools index Aligned.sortedByCoord.out.bam
