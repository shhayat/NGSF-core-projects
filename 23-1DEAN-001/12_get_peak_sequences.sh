#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=get_peak_sequences
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=6:00:00
#SBATCH --mem=40G
#SBATCH  --output=%j.out

set -eux
module load bedtools

./bedtools.static.binary getfasta -fi /datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa \
                                  -bed ${DIR}/${cellLine}_promotor_regions_common.bed \
                                  -fo ${OUTDIR}/${cellLine}_genome.masked.on.intervals_for_promotor_regions_common.fa
