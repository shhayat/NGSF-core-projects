#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=nf_chipseq
#SBATCH --cpus-per-task=40
#SBATCH --mem=185G
#SBATCH --time=40:00:00
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module --force purge
module load StdEnv/2020
module load nextflow/22.04.3
module load gentoo/2020
module load singularity/3.9.2

mkdir -p  ${SLURM_TMPDIR}/ch_results && cd ${SLURM_TMPDIR}/ch_results
mkdir -p  ${SLURM_TMPDIR}/ch_results/results
mkdir -p  ${SLURM_TMPDIR}/ch_results/work
                              
DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq
GTF="/datastore/NGSF001/analysis/references/mouse/gencode-m30/gencode.vM30.annotation.gtf"

nextflow run nf-core/chipseq -profile singularity \
                             --input ${DIR}/design.csv \
                             --genome mm10 \
                             --single_end true \
                             --blacklist ${DIR}/analysis/blacklist_file/mm10-blacklist.v2.bed.gz \
                             --narrow_peak \
                             --gtf ${GTF} \
                             -w ${SLURM_TMPDIR}/ch_results/work \
                             --outdir ${SLURM_TMPDIR}/ch_results/results
                             
                          
rsync -rvzP  ${SLURM_TMPDIR}/ch_results ${OUTDIR}

