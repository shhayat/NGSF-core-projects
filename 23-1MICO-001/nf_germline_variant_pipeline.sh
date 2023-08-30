#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=germline
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=07:00:00
#SBATCH --output=%j.out

module --force purge
module load StdEnv/2020
module load nextflow/22.10.6
module load gentoo/2020
module load singularity/3.9.2
                       
DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/
#REF=/datastore/NGSF001/analysis/references/cell_ranger_genome_builds/refdata-gex-mm10-2020-A/fasta/genome.fa
#gtf=/datastore/NGSF001/analysis/references/cell_ranger_genome_builds/refdata-gex-mm10-2020-A/genes/genes.gtf

mkdir -p ${DIR}/analysis

nextflow run nf-core/sarek -profile singularity \
                           --input ${DIR}/sample_sheet.csv \
                           --genome GATK.GRCh38 \
                           --step mapping \
                           --outdir ${DIR}/analysis \
                           
