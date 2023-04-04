#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=nf_singleCell
#SBATCH --cpus-per-task=40
#SBATCH --mem=185G
#SBATCH --time=40:00:00
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module --force purge
module load StdEnv/2020
module load nextflow/22.04.3
module load gentoo/2020
module load singularity/3.9.2

                              
DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/CellRanger_pipeline/nextflow

cd $DIR

nextflow run nf-core/scrnaseq -profile singularity \
                              --input '$DIR/samplesheet.csv' \
                              --aligner cellranger \
                              --genome GRCh38 \ 
                              -profile singularity
                              --outdir ${DIR}
