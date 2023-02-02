#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=nf_rnaseq
#SBATCH --cpus-per-task=40
#SBATCH --mem=185G
#SBATCH --time=40:00:00
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module --force purge
module load StdEnv/2020
module load nextflow/22.04.3
module load gentoo/2020
module load singularity/3.9.2

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1BETO-001B

mkdir -p  ${DIR}/analysis && cd ${DIR}/analysis
mkdir -p  ${DIR}/analysis/results
mkdir -p  ${DIR}/analysis/work
                              

GTF="/datastore/NGSF001/analysis/references/human/gencode-40/"

nextflow run nf-core/chipseq -profile singularity \
                             --input ${DIR}/design.csv \
                             --fasta \
                             --gtf ${GTF} \
                             --star_index \
                             --gtf ${GTF} \
                             -w ${DIR}/analysis/work \
                             --outdir ${DIR}/analysis/results
                             
