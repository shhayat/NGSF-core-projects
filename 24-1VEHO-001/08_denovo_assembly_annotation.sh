#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=denovo
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --time=240:00:00
#SBATCH --mem=200G
#SBATCH --output=/project/anderson/%j.out

prokka=/globalhome/hxo752/HPC/tools/prokka/bin
OUTDIR=/project/anderson/assembly_annotation

contigs=$1; shift
sample_name=$1

mkdir -p ${OUTDIR}

prokka --compliant \
       --mincontiglen 200 \
       --outdir ${OUTDIR}/${sample_name} \
       ${contigs}
       
       
