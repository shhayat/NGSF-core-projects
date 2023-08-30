#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=germline
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=07:00:00
#SBATCH --output=%j.out

module load singularity/3.9.2

sample_name=$1; shift
fq1=$1; shift
fq2=$1
