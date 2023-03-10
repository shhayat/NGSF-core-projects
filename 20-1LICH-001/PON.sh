#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=gatk-mutect2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

#loading required modules
module load gatk/4.2.2.0


gatk CreateSomaticPanelOfNormals \
   -vcfs normal1_for_pon_vcf.gz \
   -vcfs normal2_for_pon_vcf.gz \
   -vcfs normal3_for_pon_vcf.gz \
   -O pon.vcf.gz
