#!/bin/bash

#SBATCH --job-name=AddOrReplaceReadGroups
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=03:00:00
#SBATCH --mem=40G
#SBATCH  --output=%j.out
set -eux

module load picard
module load samtools

NCPU=4
sample_name=$1;

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/24-1LICH-001/analysis/star_alignment

mkdir -p $DIR/${sample_name}_tmdir

java -Xmx64G -XX:ParallelGCThreads=$NCPU -jar $EBROOTPICARD/picard.jar AddOrReplaceReadGroups \
                                    I=$DIR/${sample_name}_Aligned.sortedByCoord.out.bam \
                                    O=$DIR/${sample_name}_Aligned.sortedByCoord.RG.bam \
                                    SO=coordinate \
                                    RGID=1 \
                                    RGLB=lib1 \
                                    RGPL=ILLUMINA \
                                    RGPU=unit1 \
                                    RGSM=${sample_name} \
                                    TMP_DIR=$DIR/${sample_name}_tmdir
                                    
samtools index ${OUTDIR}/${sample_name}_Aligned.sortedByCoord.RG.bam
rm -r $DIR/${sample_name}_tmdir
