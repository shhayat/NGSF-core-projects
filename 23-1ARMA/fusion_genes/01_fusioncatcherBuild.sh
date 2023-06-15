#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_build
#SBATCH --ntasks=1
#BATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --mem=80G
#SBATCH --output=%j.out

module load python/2.7
pip2.7 install biopython

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis
fusioncatcher=/globalhome/hxo752/HPC/tools/fusioncatcher/bin

mkdir -p ${DIR}/fusioncatcher/build

${fusioncatcher}/fusioncatcher-build \
                              -o ${DIR}/fusioncatcher/build \
                              --organism="canis_familiaris" \
                              -w WEB_ENSEMBL="www.ensembl.org" \
                              --threads=16
