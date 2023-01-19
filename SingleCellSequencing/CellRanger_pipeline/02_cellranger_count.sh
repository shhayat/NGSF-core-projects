#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=cellranger-count
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=24:00:00
#SBATCH --mem=250G
#SBATCH  --output=%j.out

source /globalhome/hxo752/HPC/cell_ranger_env/bin/activate

export PATH=/datastore/NGSF001/software/tools/cellranger-7.1.0/bin:$PATH

FASTQS=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/analysis/Fastq
REF=/datastore/NGSF001/analysis/references/cell_ranger_genome_builds/refdata-gex-GRCh38-2020-A/fasta
#OUTPUT=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/analysis/

mkdir -p ${OUTPUT}
NCPUS=16
RAM_MEMORY=128
#SAMPLE_NAME=1;
SAMPLE_NAME="Brain_Tumor_3p"
cellranger count --id=${SAMPLE_NAME} \
                 --transcriptome=${REF} \
                 --fastqs=${FASTQS} \
                 --sample=${SAMPLE_NAME} \
                 --localcores=${NCPUS} \
                 --localmem=${RAM_MEMORY}
