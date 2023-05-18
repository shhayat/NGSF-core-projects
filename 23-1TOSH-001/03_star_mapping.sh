#!/bin/bash

#SBATCH --job-name=star-align
#SBATCH --constraint=skylake
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=:00:00
#SBATCH --mem=80G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

#loading required modules
module load star/2.7.9a 
module load samtools

GENOME=/datastore/NGSF001/analysis/indices/bison/ensembl.105/star/fasta_greater10000/
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
	--runThreadN 2 \
	&& samtools index Aligned.sortedByCoord.out.bam

