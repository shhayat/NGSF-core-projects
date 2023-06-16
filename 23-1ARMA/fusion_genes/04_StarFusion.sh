#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=06:00:00
#SBATCH --output=%j.out

source /globalhome/hxo752/HPC/.bashrc
#conda activate star-fusion
conda activate star-fusion

output_dir=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/starFusion
CanineStarFusionBuild=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/ctat_genome_lib_build_dir

mkdir -p ${output_dir}
STAR-Fusion --left_fq ../Rawfastq/fname.R1 \
            --right_fq ../Rawfastq/fname.R2 \
            --genome_lib_dir CanineStarFusionBuild \
            --output_dir ${output_dir}/fname.code.fusion \
            --CPU 4
                       
