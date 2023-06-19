#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=star-fusion
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=40G
#SBATCH --time=06:00:00
#SBATCH --output=%j.out

source /globalhome/hxo752/HPC/.bashrc
conda activate star-fusion

output_dir=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/starFusion
CanineStarFusionBuild=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/ctat_genome_lib_build_dir

fq1=$1; shift
fq2=$1;

mkdir -p ${output_dir}
 STAR-Fusion --genome_lib_dir ${CanineStarFusionBuild} \
             --left_fq ${fq1} \
             --right_fq ${fq2} \
             --output_dir ${output_dir} \
             --CPU 4 
conda deactivate
