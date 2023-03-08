#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=mapping
#SBATCH --ntasks=1
#BATCH --cpus-per-task=2
#SBATCH --time=00:40:00
#SBATCH --mem=40G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

set -eux

#work adapted from https://github.com/ngsf-usask/scripts/tree/main/RNAseq/22-1MILE-002
module load samtools

umi_tools=/globalhome/hxo752/HPC/anaconda3/bin
DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-001/star_alignment
RRNA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-001/analysis/rrna_intervals/rRNA_intervals_merged.bed

NCPU=4
sample_name=$1; shift
BAM=$1;

mkdir -p ${DIR}/umi_deduplication/${sample_name} && cd ${DIR}/umi_deduplication/${sample_name}

echo "Dropping ribosomal RNA reads"
samtools view -@ ${NCPU} \
              -U ${sample_name}.no-rRNA.bam \
              -O BAM \
              -L ${RRNA} \
              ${DIR}/${sample_name}/${BAM}


# keep only primary alignments
echo "Keep primary alignments, and reindex"
samtools view -@ ${NCPU} \
              -F 0x804 \
              -O BAM ${sample_name}.no-rRNA.bam > ${sample_name}.no-rRNA.primary-aln.bam \
              && samtools index ${sample_name}.no-rRNA.primary-aln.bam



umi_tools dedup -I ${sample_name}.no-rRNA.primary-aln.bam \
                --log="${sample_name}.umi.log" \
                --umi-separator=":" \
                --unpaired-reads="discard" \
                --paired --chimeric-pairs="discard" > ${sample_name}.no-rRNA.primary-aln.dedup.bam


