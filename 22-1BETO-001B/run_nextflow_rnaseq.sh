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
DATA_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1BETO-001B/Fastq

mkdir -p  ${DIR}/analysis && cd ${DIR}/analysis
mkdir -p  ${DIR}/analysis/results
mkdir -p  ${DIR}/analysis/work
                              
FASTA="/datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa"
GTF="/datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Annotation/Genes/genes.gtf"

#--star_index
#--fasta ${FASTA} \
#--gtf ${GTF} \
#--genome GRCh38 \
#--save_reference \

nextflow run nf-core/rnaseq -profile singularity \
                             --input ${DATA_DIR}/'*_R{1,2}.fastq.gz' \
                             --genome GRCh38 \
                             --save_reference TRUE \
                             -w ${DIR}/analysis/work \
                             --outdir ${DIR}/analysis/results
                             
