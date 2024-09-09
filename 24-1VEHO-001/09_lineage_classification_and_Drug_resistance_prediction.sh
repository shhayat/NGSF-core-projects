#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=mykrobe
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=20:00:00
#SBATCH --mem=10G
#SBATCH --output=/project/anderson/%j.out


source /globalhome/hxo752/HPC/.bashrc
sample_name=$1;
NCPU=2

mykrobe=/globalhome/hxo752/HPC/miniconda/bin
OUTDIR=/project/anderson/lineage_classification_and_prediction
DATA=/project/anderson/trimmed_fastq

mkdir -p ${OUTDIR}/${sample_name}

${mykrobe}/mykrobe predict --sample ${sample_name} \
                --species tb \
                --output ${OUTDIR}/${sample_name}/out.json \
                --format json_and_csv \
                --seq ${DATA}/${sample_name}_R1.fastq.gz ${DATA}/${sample_name}_R2.fastq.gz \
                -t ${NCPU}
