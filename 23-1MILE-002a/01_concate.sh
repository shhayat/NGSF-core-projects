#!/bin/bash 

#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=bcl2fastq_umi
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=2:00:00
#SBATCH --mem=40G

set -eux

module load nixpkgs/16.09
module load gcc/7.3.0
module load bcl2fastq2/2.20.0

Fastq=/datastore/NGSF001/NB551711/230718_NB551711_0078_AHL2L5AFX5/Alignment_1/20230719_041051/Fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002a/analysis



