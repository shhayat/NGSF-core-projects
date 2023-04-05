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
module load nextflow/22.10.6
module load gentoo/2020
module load singularity/3.9.2

                              
DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/CellRanger_pipeline/nextflow
REF=/datastore/NGSF001/analysis/references/cell_ranger_genome_builds/refdata-gex-mm10-2020-A/fasta/genome.fa
gtf=/datastore/NGSF001/analysis/references/cell_ranger_genome_builds/refdata-gex-mm10-2020-A/genes/genes.gtf

#mkdir -p ${DIR}/analysis/results
mkdir -p ${DIR}/analysis/results_stars

nextflow run nf-core/scrnaseq -profile singularity \
                              --input ${DIR}/sample_info.csv \
                              --skip_fastqc 'TRUE' \
                              #--aligner cellranger \
                              --aligner star \
                              --outdir ${DIR}/analysis/results_stars \
                              --fasta ${REF} \
                              --gtf ${gtf}
