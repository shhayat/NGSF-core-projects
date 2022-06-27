#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=picard
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

set -eux

module load picard/2.23.3 
BAMDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/alignment
NCPU=2

sample_name=$1

java -Xmx64G -jar $PICARD_HOME/picard.jar MarkDuplicates \
             I=${BAMDIR}/${sample_name}/${sample_name}.aligned.bam O= ${BAMDIR}/${sample_name}/${sample_name}.aligned_dedup.bam \
             M=${BAMDIR}/${sample_name}/dedup_metrics.txt VALIDATION_STRINGENCY=LENIENT \
             REMOVE_DUPLICATES=true \
             ASSUME_SORTED=true
