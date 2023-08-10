#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=chipr
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=%j.out

cd /globalhome/hxo752/HPC/tools/ChIP-R/bin
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/chipr
mkdir -p ${OUTDIR}

files=$1; shift
cellLine=$1;

./chipr -i ${files} \
      -m 1 \
      -o ${OUTDIR}/${cellLine}  
