#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=dedup
#SBATCH --ntasks=1
#BATCH --cpus-per-task=4
#SBATCH --time=03:00:00
#SBATCH --mem=80G
#SBATCH --output=%j.out

set -eux

#work adapted from https://github.com/ngsf-usask/scripts/tree/main/RNAseq/22-1MILE-002
module load samtools

umitools=/globalhome/hxo752/HPC/.local/bin

#DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002a/analysis
DIR=/datastore/NGSF001/projects/23-1MILE-002/Analysis_July2023/
RRNA=/datastore/NGSF001/projects/23-1MILE-001/Analysis/rrna_intervals/rRNA_intervals_merged.bed
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002a/analysis/deduplication

NCPU=4
sample_name=$1; shift
BAM=$1;

#mkdir -p ${OUTDIR}/${sample_name}
cd ${DIR}/deduplication/${sample_name}/
#mkdir -p ${DIR}/deduplication/${sample_name} && cd ${DIR}/deduplication/${sample_name}

#echo "Dropping ribosomal RNA reads"
#samtools view -@ ${NCPU} \
#              -U ${sample_name}.no-rRNA.bam \
#              -O BAM \
#              -L ${RRNA} \
#              ${DIR}/star_alignment/${sample_name}/${BAM}


# keep only primary alignments
#echo "Keep primary alignments, and reindex"
#samtools view -@ ${NCPU} \
#              -F 0x804 \
#              -O BAM ${sample_name}.no-rRNA.bam > ${sample_name}.no-rRNA.primary-aln.bam \
#              && samtools index ${sample_name}.no-rRNA.primary-aln.bam


${umitools}/umi_tools dedup -I ${sample_name}.no-rRNA.primary-aln.bam \
                --log="${sample_name}.umi.log" \
                --umi-separator=":" \
                --unpaired-reads="discard" \
                --paired --chimeric-pairs="discard" > ${sample_name}.no-rRNA.primary-aln.dedup.bam \
                 && samtools index ${sample_name}.no-rRNA.primary-aln.dedup.bam

#samtools sort by coordinate
samtools sort ${sample_name}.no-rRNA.primary-aln.dedup.bam -o ${OUTDIR}/${sample_name}.no-rRNA.primary-aln.dedup_sort.bam && samtools index ${OUTDIR}/${sample_name}.no-rRNA.primary-aln.dedup_sort.bam
#samtool sort by name
#samtools sort -n ${sample_name}.no-rRNA.primary-aln.dedup.bam -o ${OUTDIR}/${sample_name}.no-rRNA.primary-aln.dedup_sort.bam && samtools index ${OUTDIR}/${sample_name}.no-rRNA.primary-aln.dedup_sort.bam


