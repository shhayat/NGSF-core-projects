#!/bin/bash 

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=bcl2fastq_umi
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=24:00:00
#SBATCH --mem=80G

set -eux

#Minimum bcl2fastq is 32GB RAM, and at least 1 core (will have 8)

module load nixpkgs/16.09
module load gcc/7.3.0
module load bcl2fastq2/2.20.0

OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1TOSH-001

mkdir -p ${SLURM_TMPDIR}/fastq
bcl2fastq --runfolder-dir /datastore/NGSF001/NB551711/230505_NB551711_0069_AHLJGJBGXM/ \
            -o ${OUTDIR}/fastq \
            --no-lane-splitting
