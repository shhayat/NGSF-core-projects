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

DATA=/datastore/NGSF001/projects/21-1TOSH-001/fastq/21-1TOSH-001
GENOME=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001/indices/star-index-2.7.9a
#GFF=/datastore/NGSF001/analysis/references/bison/jhered/esab003/bison.liftoff.chromosomes.gff
GTF=/globalhome/hxo752/HPC/bison.liftoff.gffread.mod.gtf
OUTDATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001/STAR_alignment

#for i in $DATA/R2200001_S1_R1_001.fastq.gz
#do
        #R1="${i%_R1*}";
        #R2=${R1##*/};
        #fq1=${R1}_S1_R1_001.fastq.gz
	#fq2=${R1}_S1_R2_001.fastq.gz
	fq1=$DATA/R2200001_S1_R1_001.fastq.gz
	fq2=$DATA/R2200001_S1_R2_001.fastq.gz
	mkdir -p $OUTDATA/R2200001_star
	mkdir -p $OUTDATA/R2200001_star/tmp 
	#mkdir -p $OUTDATA/${R2}_star
        #mkdir -p $OUTDATA/${R2}_star/tmp 

STAR --genomeDir $GENOME \
	--readFilesCommand zcat \
	--readFilesIn $fq1 $fq2 \
	--sjdbGTFfile $GTF \
	--outSAMstrandField intronMotif \
	--outFileNamePrefix $OUTDATA/R2200001_star/star_ \
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
