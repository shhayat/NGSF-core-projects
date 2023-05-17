#!/bin/bash 

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=bcl2fastq_umi
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=24:00:00
#SBATCH --mem=80G

set -eux

module load nixpkgs/16.09
module load gcc/7.3.0
module load bcl2fastq2/2.20.0

OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1TOSH-001/analysis

folder_name=$1;

mkdir -p ${OUTDIR}/fastq_folders
bcl2fastq --runfolder-dir ${folder_name}/ \
            -o ${OUTDIR}/fastq_folders/${folder_name} \
            --no-lane-splitting
