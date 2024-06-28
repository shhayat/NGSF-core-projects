#!/bin/bash

#SBATCH --job-name=star-align
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=1:00:00
#SBATCH --mem=40G
#SBATCH  --output=%j.out
set -eux

#loading required modules
module load star/2.7.11a
module load samtools

GENOME=/datastore/NGSF001/analysis/indices/human/GRCh38.d1.vd1_star_genomebuild
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/24-1LICH-001/analysis/star_alignment
NCPU=4

mkdir -p ${OUTDIR}

sample_name=$1; shift
fq1=$1; shift
fq2=$1

cd ${OUTDIR}

STAR --genomeDir $GENOME \
     --readFilesCommand zcat \
     --readFilesIn ${fq1} ${fq2} \
     --outSAMtype BAM SortedByCoordinate \
     --runThreadN ${NCPU} \
     --alignIntronMax 1000000 \
     --alignIntronMin 20 \
     --alignMatesGapMax 1000000 \
     --alignSJDBoverhangMin 1 \
     --alignSJoverhangMin 8 \
     --alignSoftClipAtReferenceEnds Yes \
     --chimJunctionOverhangMin 15 \
     --chimMainSegmentMultNmax 1 \
     --chimOutJunctionFormat 1 \
     --chimSegmentMin 15 \
     --limitSjdbInsertNsj 1200000 \
     --outFilterIntronMotifs None \
     --outFilterMatchNminOverLread 0.33 \
     --outFilterMismatchNmax 999 \
     --outFilterMismatchNoverLmax 0.1 \
     --outFilterMultimapNmax 20 \
     --outFilterScoreMinOverLread 0.33 \
     --twopassMode Basic \
     --outSAMmapqUnique 60 \
     --outFileNamePrefix ${sample_name}_
     && samtools index ${sample_name}_Aligned.sortedByCoord.out.bam 
