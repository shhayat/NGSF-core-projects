#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=motif_discovery
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=4:00:00
#SBATCH --mem=20G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

#there was environment problem while installing meme with conda. 
#For fixing this issue conda env "meme" was created 
#./globalhome/hxo752/HPC/anaconda3/condabin/conda create -n meme -c bioconda meme 
#For activating "meme" env first source .bashrc then activate meme env then use meme commands
source $HOME/.bashrc
conda activate meme

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/IDR
cd /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/

#select peaks with the strongest signal for motif finding
#sort -k 7,7nr  ${DIR}/${bed_peak} | head -n 200 > ${DIR}/motif_discovery/${sample_name}_top.bed

#since we have limited number of peaks we will not select top peaks and proceed with meme-chip
meme-chip -oc motif_discovery ${DIR}/genome.idr_intervals.fa
