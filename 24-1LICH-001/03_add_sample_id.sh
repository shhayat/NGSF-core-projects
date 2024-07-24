#!/bin/bash

#SBATCH --job-name=AddOrReplaceReadGroups
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=03:00:00
#SBATCH --mem=40G
#SBATCH  --output=%j.out
set -eux


gatk AddOrReplaceReadGroups \
    I=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/24-1LICH-001/analysis/star_alignment/R2200133_Aligned.sortedByCoord.out.bam \
    O=/path/to/output/R2200133_Aligned.sortedByCoord.withRG.bam \
    RGID=1 \
    RGLB=lib1 \
    RGPL=illumina \
    RGPU=unit1 \
    RGSM=R2200133
