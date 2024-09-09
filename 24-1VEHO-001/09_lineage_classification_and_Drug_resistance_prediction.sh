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
sample_name=$1;

mykrobe=/globalhome/hxo752/HPC/tools/mykrobe-0.13.0
OUTDIR=/project/anderson/assembly_annotation

mkdir -p ${OUTDIR}/${sample_name}

mykrobe predict --sample ${sample_name} \
                --species tb \
                --output ${OUTDIR}/${sample_name}/out.json \
                --format json \
                --seq ${OUTDIR}/${sample_name}/reads.fq.gz
