#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=nf
#SBATCH --cpus-per-task=40
#SBATCH --mem=185G
#SBATCH --time=20:00:00
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module --force purge
module load StdEnv/2020
module load nextflow/22.04.3
module load gentoo/2020
module load singularity/3.9.2

OUTDIR="/globalhome/hxo752/HPC/DNAMethylation"
DATA="/datastore/NGSF001/datasets/bisulfite_seq/"
#config_file=$1;
condition="Colon_Normal_Primary"

mkdir -p  ${SLURM_TMPDIR}/chip_results && cd ${SLURM_TMPDIR}/chip_results
mkdir -p  ${SLURM_TMPDIR}/chip_results/results
mkdir -p  ${SLURM_TMPDIR}/chip_results/work

echo ${SLURM_TMPDIR}

#nextflow run nf-core/methylseq -profile singularity -c testdata.config
nextflow run nf-core/methylseq -profile singularity \
                               --input ${DATA}/${condition}/'*_{1,2}.fastq.gz' \
                               -w ${SLURM_TMPDIR}/chip_results/work \
                               --outdir ${SLURM_TMPDIR}/chip_results/results \
                               --genome GRCh38 \
                               --single_end false \
                               -resume

rsync -rvzP  ${SLURM_TMPDIR}/chip_results ${OUTDIR}
