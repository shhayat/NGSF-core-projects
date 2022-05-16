#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=star_mapping
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=2:00:00
#SBATCH --mem=4G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

#loading required modules
module load star/2.7.9a 
module load samtools

DATA=/datastore/NGSF001/projects/21-1TOSH-001/fastq/21-1TOSH-001
GENOME=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001/indices/star-index-2.7.9a
GFF=/datastore/NGSF001/analysis/references/bison/jhered/esab003/bison.liftoff.chromosomes.gff
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
	--sjdbGTFfile $GFF \
	--sjdbGTFtagExonParentTranscript Parent \
	--outSAMstrandField intronMotif \
	--outFileNamePrefix $OUTDATA/R2200001_star/star_ \
	--outSAMtype BAM SortedByCoordinate \
	--outFilterIntronMotifs RemoveNoncanonical \
	--runThreadN 4 \
	&& samtools index $OUTDATA/R2200001_star/star_Aligned.sortedByCoord.out.bam 
#done
