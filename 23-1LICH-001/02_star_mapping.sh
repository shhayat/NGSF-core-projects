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

DATA=/datastore/NGSF001/projects/23-1LICH-001/concatenated_latest_fastq_with_previous_fastq
GENOME=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/depletion_test/human/indices/gencode-40
GTF=/datastore/NGSF001/analysis/references/human/gencode-40/gencode.v40.annotation.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001/analysis/star_alignment
NCPU=4

rsync -avzP /datastore/NGSF001/analysis/references/human/gencode-40/gencode.v40.annotation.gtf ${SLURM_TMPDIR}/

mkdir -p ${OUTDIR}
sample_name=$1; shift
fq1=$1; shift
fq2=$1

rsync -v $fq1 ${SLURM_TMPDIR}
rsync -v $fq2 ${SLURM_TMPDIR}

mkdir -p ${SLURM_TMPDIR}/${sample_name} && cd ${SLURM_TMPDIR}/${sample_name}

STAR --genomeDir $GENOME \
	--readFilesCommand zcat \
	--readFilesIn ${fq1} ${fq2} \
	--outSAMstrandField intronMotif \
	--outSAMtype BAM SortedByCoordinate \
	--outFilterIntronMotifs RemoveNoncanonical \
	--sjdbGTFfile ${GTF} \
	--runThreadN ${NCPU} \
	&& samtools index Aligned.sortedByCoord.out.bam 
