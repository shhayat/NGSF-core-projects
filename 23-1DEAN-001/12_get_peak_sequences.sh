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
cd /globalhome/hxo752/HPC/tools

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis

#extract peak sequences
./bedtools.static.binary getfasta -fi /datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa \
                                  -bed ${DIR}/common_peaks_regions.bed \
                                  -fo ${DIR}/common_peak_sequences.fa

#extract peak sequences and 2000bp region upstream downstream of peak
./bedtools.static.binary flank -i ${DIR}/common_peaks_regions.bed 
                              -g /datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa \
                              -b 2000 |
./bedtools.static.binary getfasta -fi /datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa \
                                  -bed - \
                                  -fo ${DIR}/common_peaks_sequences_with_2000bp_upstream_and_downstream.fa
