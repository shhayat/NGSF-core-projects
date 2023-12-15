#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=chipr
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=%j.out

#Since IDR tool works with only 2 replicate and we have 3 replicates per cell line. Due to which we choose to work with chipr tool
set -eux
module purge
module load python/3.10
module load scipy-stack/2023a
source $HOME/venvs/chip-r/bin/activate

OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/chipr

files=$1; shift
cellLine=$1;
mkdir -p ${OUTDIR}


chipr -i ${files} \
      -m 2 \
      -o ${OUTDIR}/${cellLine}
      --rankmethod qvalue
awk '{if($5 >= 540) print $0}' ${OUTDIR}/${cellLine}_optimal.bed > ${OUTDIR}/${cellLine}_optimal_filtered_v1.bed

#sort on -log10(qvalue)
sort -k 9,9n ${OUTDIR}/${cellLine}_optimal_filtered_v1.bed > ${OUTDIR}/${cellLine}_optimal_filtered_sorted_v1.bed

#prep file for motif discovery
cut -f 1,2,3 ${OUTDIR}/${cellLine}_optimal_filtered_sorted_v1.bed > ${OUTDIR}/${cellLine}_optimal_filtered_3_columns_v1.bed 


#chipr -i ${files} \
#      -m 1 \
#      -o ${OUTDIR}/${cellLine}
#awk '{if($5 >= 540) print $0}' ${OUTDIR}/${cellLine}_optimal.bed > ${OUTDIR}/${cellLine}_optimal_filtered.bed

#sort on -log10(pvalue)
#sort -k 8,8nr ${OUTDIR}/${cellLine}_optimal_filtered.bed > ${OUTDIR}/${cellLine}_optimal_filtered_sorted.bed

#prep file for motif discovery
#cut -f 1,2,3 ${OUTDIR}/${cellLine}_optimal_filtered_sorted.bed > ${OUTDIR}/${cellLine}_optimal_filtered_3_columns.bed 


