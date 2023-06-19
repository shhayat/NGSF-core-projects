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
conda activate star-fusion

star_dir=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/star_alignment
output_dir=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/starFusion
CanineStarFusionBuild=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/ctat_genome_lib_build_dir

fq1=$1;
fq2=$1;
sample_name=$1

mkdir -p ${output_dir}
 STAR-Fusion --genome_lib_dir CanineStarFusionBuild \
             -J ${star_dir}/${sample_name}/Chimeric.out.junction \
             --output_dir ${output_dir} \
             --CPU 4 
