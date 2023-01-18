#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=cellranger-count
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=2:00:00
#SBATCH --mem=250G
#SBATCH  --output=%j.out

export PATH=/datastore/NGSF001/software/tools/cellranger-7.1.0/bin:$PATH

FASTQS=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/analysis/Fastq
REF=/datastore/NGSF001/analysis/references/cell_ranger_genome_builds/refdata-gex-GRCh38-2020-A/fasta
NCPUS=20
RAM_MEMORY=250
#SAMPLE_NAME=1;
SAMPLE_NAME="Brain_Tumor_3p"
cellranger count --id=${SAMPLE_NAME} \
                 --transcriptome=${REF} \
                 --fastqs=${FASTQS} \
                 --sample=${SAMPLE_NAME} \
                 --localcores=${NCPUS} \
                 --localmem=${RAM_MEMORY}
