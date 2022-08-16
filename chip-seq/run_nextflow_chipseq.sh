#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=ivybridge
#SBATCH --job-name=nf_chipseq
#SBATCH --cpus-per-task=16
#SBATCH --mem=30G
#SBATCH --time=10:00:00
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

#module --force purge
module spider nextflow/22.04.3
module spider singularity/3.4.1

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq
GTF="/datastore/NGSF001/analysis/references/mouse/gencode-m30/gencode.vM30.annotation.gtf"
mkdir -p ${DIR}/chipseq-nf
chmod a+x ${DIR}/.nextflow/cache

#nextflow run nf-core/chipseq -profile singularity --input chip_design.csv --genome GRCm38 --single_end true
nextflow run nf-core/chipseq -profile singularity \
                             --input ${DIR}/chip_design.csv \
                             --single_end true \
                             --fasta ${DIR}/analysis/indices_mouse/genome.fa \
                             --bwa_index ${DIR}/analysis/indices_mouse/genome.fa \
                             --blacklist ${DIR}/analysis/blacklist_file/mm10-blacklist.v2.bed.gz \
                             --gtf ${GTF} \
                             -w ${DIR}/chipseq-nf
                            
