#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=mapping
#SBATCH --ntasks=1
#BATCH --cpus-per-task=2
#SBATCH --time=03:00:00
#SBATCH --mem=60G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

set -eux

module load star/2.7.9a 
module load samtools

NCPU=4

OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002/analysis/star_alignment
star=/datastore/NGSF001/software/tools/STAR-2.7.4a/bin/Linux_x86_64
GENOME=/datastore/NGSF001/projects/23-1MILE-001/Analysis/indices/star-index

sample_name=$1; shift
fq1=$1; shift
fq2=$1;

mkdir -p ${OUTDIR}/${sample_name} && cd ${OUTDIR}/${sample_name}

STAR --genomeDir ${GENOME} \
	--readFilesCommand zcat \
	--readFilesIn ${fq1} ${fq2} \
	--outSAMtype BAM SortedByCoordinate \
	--runThreadN ${NCPU} \
	&& samtools index Aligned.sortedByCoord.out.bam 
	
