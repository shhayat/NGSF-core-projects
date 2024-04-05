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
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/motif_discovery/ChIPMunk
mkdir -p $OUTDIR

#peaks located in promoter region of the gene were extracted from the peak annotation files and sequences were retrived 
#In this step the sequneces will be passed through different denovo motif discovery tools to find the motif that is conseverd across sequences

#ChIPMunk
#java -Xms512M -XX:ParallelGCThreads=$NCPU -cp /globalhome/hxo752/HPC/tools/chipmunk.jar \
#                                          ru.autosome.ChIPMunk \
#                                          s:$DATA/common_peaks_sequences_with_2000bp_upstream_and_downstream.fa > $OUTDIR/results_common_peaks_sequences_with_2000bp_upstream_and_downstream.txt

#java -Xms512M -XX:ParallelGCThreads=$NCPU -cp /globalhome/hxo752/HPC/tools/chipmunk.jar \
#                                          ru.autosome.ChIPMunk \
#                                          s:$DATA/common_peak_sequences.fa > $OUTDIR/results_common_peak_sequences.txt
                                  
#MEME
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/motif_discovery/MEME
mkdir -p $OUTDIR
#/globalhome/hxo752/HPC/anaconda3/envs/meme/bin/meme -oc $OUTDIR/common_peaks_sequences_with_2000bp_upstream_and_downstream \
#                                                    -nmotifs 10 \
#                                                    -maxsize 800000 \
#                                                    $DATA/common_peaks_sequences_with_2000bp_upstream_and_downstream.fa

#/globalhome/hxo752/HPC/anaconda3/envs/meme/bin/meme -oc $OUTDIR/common_peak_sequences \
#                                                    -nmotifs 10 \
#                                                    -maxsize 800000 \
#                                                    $DATA/common_peak_sequences.fa

#GLAM2
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/motif_discovery/GLAM2
mkdir -p $OUTDIR/common_peaks_sequences_with_2000bp_upstream_and_downstream
/globalhome/hxo752/HPC/anaconda3/envs/meme/bin/glam2 n $DATA/common_peaks_sequences_with_2000bp_upstream_and_downstream.fa \
                                                    -r 10 \
                                                    -o $OUTDIR/common_peaks_sequences_with_2000bp_upstream_and_downstream

mkdir -p $OUTDIR/common_peak_sequences
/globalhome/hxo752/HPC/anaconda3/envs/meme/bin/glam2 n $DATA/common_peak_sequences.fa \
                                                    -r 10 \
                                                    -o $OUTDIR/common_peak_sequences
                                                
