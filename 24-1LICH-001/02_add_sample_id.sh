#!/bin/bash

#SBATCH --job-name=AddOrReplaceReadGroups
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=03:00:00
#SBATCH --mem=40G
#SBATCH  --output=%j.out
set -eux

module load samtools

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/24-1LICH-001/analysis/star_alignment
cd ${DIR}

sample_name=$1;

/globalhome/hxo752/HPC/tools/IMAPR/tools/gatk-4.1.8.1/gatk AddOrReplaceReadGroups \
                                                            I=$DIR/${sample_name}_Aligned.sortedByCoord.out.bam \
                                                            O=$DIR/${sample_name}_Aligned.sortedByCoord.RG.bam \
                                                            RGID=1 \
                                                            RGLB=lib1 \
                                                            RGPL=illumina \
                                                            RGPU=unit1 \
                                                            RGSM=${sample_name} \
                                                            && samtools index ${OUTDIR}/${sample_name}_Aligned.sortedByCoord.RG.bam
