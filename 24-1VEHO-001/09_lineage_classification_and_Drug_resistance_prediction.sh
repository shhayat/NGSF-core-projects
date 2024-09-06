#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=mykrobe
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=20:00:00
#SBATCH --mem=10G
#SBATCH --output=/project/anderson/%j.out


source /globalhome/hxo752/HPC/.bashrc

mykrobe=/globalhome/hxo752/HPC/tools/mykrobe-0.13.0
OUTDIR=/project/anderson/assembly_annotation


mykrobe predict --sample my_sample_name \
                --species tb \
                --output ${OUTDIR}//out.json \
                --format json \
                --seq reads.fq.gz
