#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_build
#SBATCH --ntasks=1
#BATCH --cpus-per-task=8
#SBATCH --time=10:00:00
#SBATCH --mem=60G
#SBATCH --output=%j.out

#module load python/2.7
conda activate fusioncatcher

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis
#fusioncatcher=/globalhome/hxo752/HPC/tools/fusioncatcher/bin

mkdir -p ${DIR}/fusioncatcher/build
#cd ${fusioncatcher}
fusioncatcher-build \
                -o ${DIR}/fusioncatcher/build \
                --organism='canis_familiaris' \
                --ftp-ensembl-path='https://ftp.ensembl.org/pub/current_fasta/canis_lupus_familiaris/' \
                --threads=8
conda deactivate
