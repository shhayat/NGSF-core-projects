#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=rm_rrna
#SBATCH --ntasks=1
#BATCH --cpus-per-task=2
#SBATCH --time=03:00:00
#SBATCH --mem=20G
#SBATCH --output=%j.out

set -eux

#work adapted from https://github.com/ngsf-usask/scripts/tree/main/RNAseq/22-1MILE-002
module load samtools
DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001/analysis/star_alignment
RRNA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001/analysis/rrna_intervals/rRNA_intervals_merged.bed
NCPU=2
sample_name=$1; shift
BAM=$1;

echo "Dropping ribosomal RNA reads"
samtools view -@ ${NCPU} \
              -U ${DIR}/${sample_name}/Aligned.sortedByCoord.no.rrna.bam\
              -O BAM \
              -L ${RRNA} \
              ${DIR}/${sample_name}/${BAM} && \
              samtools index ${DIR}/${sample_name}/Aligned.sortedByCoord.no.rrna.bam

#GTF file needs to be modified for running RNASeQC
GTF=/datastore/NGSF001/analysis/references/human/gencode-40/gencode.v40.annotation_mod.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001/analysis/rnaseqc_after_rrna_removal
mkdir -p ${OUTDIR}

cd /globalhome/hxo752/HPC/venvs/rnaseqc
./rnaseqc.v2.4.2.linux \
         ${GTF} \
         ${DIR}/${sample_name}/Aligned.sortedByCoord.no.rrna.bam \
         --sample=${sample_name} \
         ${OUTDIR}
         
