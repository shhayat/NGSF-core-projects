#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=star_fusion
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=80G
#SBATCH --time=48:00:00
#SBATCH --output=%j.out

module load singularity/3.9.2

output_dir=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/starFusion
CanineStarFusionBuild=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/ctat_genome_lib_build_dir

sample_name=$1; shift
fq1=$1; shift
fq2=$1

mkdir -p ${output_dir}/${sample_name}

singularity exec -e -B `pwd` -B ${CanineStarFusionBuild} \
                /globalhome/hxo752/HPC/tools/star-fusion.v1.11.0.simg \
                STAR-Fusion \
                --left_fq ${fq1} \
                --right_fq ${fq2} \
                --genome_lib_dir ${CanineStarFusionBuild} \
                -O ${output_dir}/${sample_name} \
                --FusionInspector validate \
                --examine_coding_effect
