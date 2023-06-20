#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=80G
#SBATCH --time=40:00:00
#SBATCH --output=%j.out

/globalhome/hxo752/HPC/tools/star-fusion.v1.11.0.simg
