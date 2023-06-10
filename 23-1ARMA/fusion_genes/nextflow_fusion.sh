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

                              
DIR=/globalhome/hxo752/HPC/
GTF=/datastore/NGSF001/analysis/references/iGenomes/Dog/Canis_familiaris/Ensembl/CanFam3.1/Annotation/Genes/genes.gtf
GENOME=/datastore/NGSF001/analysis/references/iGenomes/Dog/Canis_familiaris/Ensembl/CanFam3.1/Sequence/WholeGenomeFasta/genome.fa

mkdir -p ${DIR}/analysis/results_star

nextflow run nf-core/scrnaseq -profile singularity \
                              --input ${DIR}/sample_info.csv \
                              --skip_fastqc 'TRUE' \
                              --aligner star \
                              --outdir ${DIR}/analysis/results_star \
                              --fasta ${REF} \
                              --gtf ${gtf}
