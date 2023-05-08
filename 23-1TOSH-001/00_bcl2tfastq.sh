#!/bin/bash 

#SBATCH --job-name=bcl2fastq_umi
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=0-02:00:00
#SBATCH --mem=36G

set -eux

#Minimum bcl2fastq is 32GB RAM, and at least 1 core (will have 8)

module load nixpkgs/16.09
module load gcc/7.3.0
module load bcl2fastq2/2.20.0

OUTDIR=/datastore/NGSF001/projects/23-1TOSH-001

mkdir -p ${SLURM_TMPDIR}/fastq
bcl2fastq --runfolder-dir /datastore/NGSF001/NB551711/230505_NB551711_0069_AHLJGJBGXM/ \
            -o ${SLURM_SUBMIT_DIR}/fastq \
            --no-lane-splitting


rsync -rvzP ${SLURM_TMPDIR}/fastq ${OUTDIR}
