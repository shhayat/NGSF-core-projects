#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=denovo_motif_analysis
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=24:00:00
#SBATCH --mem=80G
#SBATCH  --output=%j.out

set -eux
NCPU=2

DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis

java -Xms512M -XX:ParallelGCThreads=$NCPU -cp /globalhome/hxo752/HPC/tools/chipmunk.jar \
                                          ru.autosome.ChIPMunk \
                                          s:$DATA/common_peaks_sequences_with_2000bp_upstream_and_downstream.fa > $DATA/results_common_peaks_sequences_with_2000bp_upstream_and_downstream.txt


java -Xms512M -XX:ParallelGCThreads=$NCPU -cp /globalhome/hxo752/HPC/tools/chipmunk.jar \
                                          ru.autosome.ChIPMunk \
                                          s:$DATA/common_peak_sequences.fa > $DATA/results_common_peak_sequences.txt
