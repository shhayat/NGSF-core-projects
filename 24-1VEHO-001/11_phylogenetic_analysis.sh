#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=pylogentic_analysis
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --time=480:00:00
#SBATCH --mem=200G
#SBATCH --output=/project/anderson/%j.out


sample_name=$1;
NCPU=32
OUTDIR=/project/anderson/pylogenetic_analysis
module load raxml-ng/1.2.0 

mkdir -p ${OUTDIR}

#generate multiple sequence alignment file

#run phylogenetic analysis with gamma model
raxml-ng --msa alignment.fa \
        --model GTR+G \
         --bs-trees 200 \
         --threads ${NCPU}
         
         
