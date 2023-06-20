#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=star-fusion
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=80G
#SBATCH --time=10:00:00
#SBATCH --output=%j.out

source /globalhome/hxo752/HPC/.bashrc
conda activate star-fusion

#starfusion=/globalhome/hxo752/HPC/tools/STAR-Fusion
output_dir=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/starFusion
#CanineStarFusionBuild=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/ctat_genome_lib_build_dir
CanineStarFusionBuild=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/ctat_genome_lib_build_dir
sample_name=$1; shift
fq1=$1; shift
fq2=$1

mkdir -p ${output_dir}/${sample_name}

STAR-Fusion --genome_lib_dir ${CanineStarFusionBuild} \
             --left_fq ${fq1} \
             --right_fq ${fq2} \
             --output_dir ${output_dir}/${sample_name} \
             --CPU 1

conda deactivate


#Extracting the fusion genes that will be used as input for fusion inspector

cut -f1  ${output_dir}/${sample_name}/star-fusion.fusion_predictions.abridged.tsv >  ${output_dir}/${sample_name}/${sample_name}_fusionInspectorInput1.txt

tail -n +2 ${output_dir}/${sample_name}/${sample_name}_fusionInspectorInput1.txt > ${output_dir}/${sample_name}/${sample_name}_fusionInspectorInput.txt

rm ${output_dir}/${sample_name}/${sample_name}_fusionInspectorInput1.txt
