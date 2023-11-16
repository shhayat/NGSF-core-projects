#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=star_fusion
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=07:00:00
#SBATCH --output=%j.out

module load singularity/3.9.2

#output_dir=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/urothelial_carcinoma/analysis/
#output_dir=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/
output_dir=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/analysis/hemangiosarcoma
#output_dir=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/squamous_cell_carcinomas/analysis/
#CanineStarFusionBuild=/datastore/NGSF001/projects/ARMA_NTRK_Fusion/ctat_genome_lib_build_dir_ROS_Cfam_1.0
CanineStarFusionBuild=/datastore/NGSF001/projects/ARMA_NTRK_Fusion/Fusion_events/genome_build_and_required_databases/ctat_genome_lib_build_dir_Cfam3.1_NCBI

sample_name=$1; shift
fq1=$1; shift
fq2=$1

mkdir -p ${output_dir}/${sample_name}

#for paired end samples
singularity exec -e -B `pwd` -B ${CanineStarFusionBuild} \
                /globalhome/hxo752/HPC/tools/star-fusion.v1.11.0.simg \
                STAR-Fusion \
                --left_fq ${fq1} \
                --right_fq ${fq2} \
                --genome_lib_dir ${CanineStarFusionBuild} \
                -O ${output_dir}/${sample_name}_latest \
                --min_FFPM 0 \
                --no_filter \
                --no_single_fusion_per_breakpoint \
                --FusionInspector validate \
                --examine_coding_effect

#for single ended samples
#singularity exec -e -B `pwd` -B ${CanineStarFusionBuild} \
#                /globalhome/hxo752/HPC/tools/star-fusion.v1.11.0.simg \
#                STAR-Fusion \
#                --left_fq ${fq} \
#                --genome_lib_dir ${CanineStarFusionBuild} \
#                -O ${output_dir}/${sample_name} \
#                --FusionInspector validate \
#                --examine_coding_effect
