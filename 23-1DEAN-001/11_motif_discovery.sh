#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=motif_discovery
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=6:00:00
#SBATCH --mem=40G
#SBATCH  --output=%j.out

set -eux
#module purge
#module load python/3.10
#module load scipy-stack/2023a
#source $HOME/venvs/meme/bin/activate

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/chipr
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/motif_finding

mkdir -p ${OUTDIR}

cellLine=$1;

#for motif discovery step repeat-masked version of the genome is required where all repeat sequences have been replaced with Ns
#we will generate masked genome based on peak intervals in idr_filtered.bed 
cd /globalhome/hxo752/HPC/tools
#chmod a+x bedtools.static.binary
#./bedtools.static.binary getfasta -fi /datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa \
#                                  -bed ${DIR}/${cellLine}_optimal_filtered_3_columns.bed \
#                                  -fo ${OUTDIR}/${cellLine}_genome.masked.on.idr_intervals.fa

#cd ${OUTDIR}
#proceed with meme-chip
#/globalhome/hxo752/HPC/anaconda3/envs/meme/bin/meme-chip -oc ${OUTDIR}/${cellLine}_motif_discovery ${OUTDIR}/${cellLine}_genome.masked.on.idr_intervals.fa

./bedtools.static.binary getfasta -fi /datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa \
                                  -bed ${DIR}/${cellLine}_promotor_regions_common.bed \
                                  -fo ${OUTDIR}/${cellLine}_genome.masked.on.intervals_for_promotor_regions_common.fa
                                  
#meme-chip for promoters
/globalhome/hxo752/HPC/anaconda3/envs/meme/bin/meme-chip -oc ${OUTDIR}/${cellLine}_motif_discovery_for_common_promotor_regions -meme-nmotifs 10 ${OUTDIR}/${cellLine}_genome.masked.on.intervals_for_promotor_regions_common.fa


