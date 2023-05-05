#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=nf_metagenomics
#SBATCH --cpus-per-task=40
#SBATCH --mem=185G
#SBATCH --time=40:00:00
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module --force purge
module load StdEnv/2020
module load nextflow/22.10.6
module load gentoo/2020
module load singularity/3.9.2

                              
DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/Metagenomics/
#EF=/datastore/NGSF001/analysis/references/cell_ranger_genome_builds/refdata-gex-mm10-2020-A/fasta/genome.fa
#gtf=/datastore/NGSF001/analysis/references/cell_ranger_genome_builds/refdata-gex-mm10-2020-A/genes/genes.gtf

mkdir -p ${DIR}/analysis/results

nextflow run nf-core/ampliseq -profile singularity \
                              --input "${DIR}/sample_info.tsv" \
                              --metadata "${DIR}/metadata.tsv" \
                              --skip_cutadapt 'TRUE' \
                              --metadata_category "Control_FL,Inulin_FL" \
                              --max_cpus 40 \
                              --max_memory '185GB' \
                              --outdir ${DIR}/analysis/results
