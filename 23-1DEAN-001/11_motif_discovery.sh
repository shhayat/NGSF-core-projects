#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=motif_discovery
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=4:00:00
#SBATCH --mem=20G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

set -eux

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/chipr
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/motif_finding

mkdir -p ${OUTDIR}

cellLine=1; shift

#for motif discovery step repeat-masked version of the genome is required where all repeat sequences have been replaced with Ns
#we will generate masked genome based on peak intervals in idr_filtered.bed 
cd /globalhome/hxo752/HPC/tools
chmod a+x bedtools.static.binary
./bedtools.static.binary getfasta -fi /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/genome.fa \
                                  -bed ${DIR}/${cellLine}_optimal_filtered_3_columns.bed \
                                  -fo ${OUTDIR}/${cellLine}_genome.masked.on.idr_intervals.fa

#there was environment problem while installing meme with conda. 
#For fixing this issue conda env "meme" was created 
#./globalhome/hxo752/HPC/anaconda3/condabin/conda create -n meme -c bioconda meme 
#For activating "meme" env first source .bashrc then activate meme env then use meme commands
source $HOME/.bashrc
conda activate meme

#select peaks with the strongest signal for motif finding
#sort -k 7,7nr  ${DIR}/${bed_peak} | head -n 200 > ${DIR}/motif_discovery/${sample_name}_top.bed

#since we have limited number of peaks we will not select top peaks and proceed with meme-chip
meme-chip -oc motif_discovery ${OUTDIR}/${cellLine}_genome.masked.on.idr_intervals.fa
