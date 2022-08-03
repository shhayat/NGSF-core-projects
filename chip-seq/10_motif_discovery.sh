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

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/


#mkdir -p ${DIR}/motif_discovery

bed_peak=$1; 
#sample_name=1;


bedtools getfasta -fi /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/indices_mouse/genome.fa \
                  -bed /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/IDR/idr.bed \
                  -fo /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/IDR/genome.idr_intervals.bed
#bedtools getfasta -fo CTCF_top500_peak_seq.fa -fi hg38.masked.fa -bed ENCFF693MY_top500.bed

#dreme -p CTCF_top500_peak_seq.fa -oc dreme_out


#select peaks with the strongest signal for motif finding
#sort -k 7,7nr  ${DIR}/${bed_peak} | head -n 200 > ${DIR}/motif_discovery/${sample_name}_top.bed

meme-chip ${sample_name}_top.bed -oc ${DIR}/motif_discovery
