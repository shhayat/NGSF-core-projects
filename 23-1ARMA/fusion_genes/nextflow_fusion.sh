#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=nf_rnafusion
#SBATCH --cpus-per-task=40
#SBATCH --mem=185G
#SBATCH --time=40:00:00
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module --force purge
module load StdEnv/2020
module load nextflow/22.10.6
module load gentoo/2020
module load singularity/3.9.2

star_indice=                              
fastq_dir=/globalhome/hxo752/HPC/

mkdir -p ${DIR}/analysis/results_star

nextflow run nf-core/scrnaseq -profile singularity \
                              --star_fusion \
                              --genome CanFam3.1 \
                              --reads ${fastq_dir}/*{1,2}.fastq.gz \
                              --star_index ${star_indice} \
                              --starfusion_build 'TRUE' \
                              --outdir ${DIR}/analysis/star_fusion \
                              --max_memory '185.GB' \
                              --max_cpus 40
                              
