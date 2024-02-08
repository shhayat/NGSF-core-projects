#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=cellranger-count
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=24:00:00
#SBATCH --mem=128G
#SBATCH  --output=%j.out

export PATH=/globalhome/hxo752/HPC/tools/cellranger-7.1.0/bin:$PATH

BCL_FOLDER=/datastore/NGSF001/NB551711/231219_NB551711_0089_AHKH3NBGXV/Data/Intensities/BaseCalls

cellranger mkfastq --run=${BCL_FOLDER} --lane
