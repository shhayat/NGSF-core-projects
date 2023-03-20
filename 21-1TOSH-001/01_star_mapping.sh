#!/bin/bash

#SBATCH --job-name=star-align
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=1:25:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

#loading required modules
module load star/2.7.9a 
module load samtools

DATA=/datastore/NGSF001/projects/21-1TOSH-001/new_analysis/Trimming
GENOME=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001/indices/star-index
OUTDATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001/Alignment_v109

sample_name=$1;
fq1=$1;
fq2=$1;

STAR --genomeDir $GENOME \
	--readFilesCommand zcat \
	--readFilesIn $fq1 $fq2 \
	--outSAMstrandField intronMotif \
	--outFileNamePrefix ${OUTDATA}/${sample_name}/star_ \
	--outSAMtype BAM SortedByCoordinate \
	--outFilterIntronMotifs RemoveNoncanonical \
	--sjdbGTFfeatureExon exon \
	--runThreadN 4 \
	&& samtools index $OUTDATA/R2200001_star/star_Aligned.sortedByCoord.out.bam 
	
	#STAR --genomeDir $GENOME \
	#--readFilesCommand zcat \
	#--readFilesIn $fq1 $fq2 \
	#--sjdbGTFfile $GFF \
	#--sjdbGTFtagExonParentTranscript Parent \
	#--sjdbGTFtagExonParentGene ID \
	#--outSAMstrandField intronMotif \
	#--outFileNamePrefix $OUTDATA/R2200001_star/star_ \
	#--outSAMtype BAM SortedByCoordinate \
	#--outFilterIntronMotifs RemoveNoncanonical \
	#--runThreadN 4 \
	#&& samtools index $OUTDATA/R2200001_star/star_Aligned.sortedByCoord.out.bam 
#done
