#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=star_fusion
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=10:00:00
#SBATCH --output=%j.out


dir=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hemangiosarcoma/analysis/
sample_name=$1;

mkdir -p ${dir}/NTRK_fusions

grep "NTRK" ${dir}/starFusion/${sample_name}/FusionInspector-validate/finspector.FusionInspector.fusions.abridged.tsv > \
                                                                                                              ${dir}/NTRK_fusions/${sample_name}_NTRKfuisons.tsv

