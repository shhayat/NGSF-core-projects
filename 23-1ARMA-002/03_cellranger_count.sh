#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=cellranger-count
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=24:00:00
#SBATCH --mem=128G
#SBATCH  --output=%j.out

export PATH=/globalhome/hxo752/HPC/tools/cellranger-7.1.0/bin:$PATH

NCPUS=16
RAM_MEMORY=128

FASTQS=/datastore/NGSF001/projects/2023/23-1ARMA-002/analysis/Fastq
REF=/datastore/NGSF001/analysis/references/cell_ranger_genome_builds/CanFam6_index
OUTPUT=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA-002/analysis/count_files
mkdir -p ${OUTPUT}
cd ${OUTPUT}
SAMPLE_NAME=$1;

/globalhome/hxo752/HPC/tools/cellranger-7.1.0/bin/cellranger count --id=${SAMPLE_NAME} \
                 --transcriptome=${REF} \
                 --fastqs=${FASTQS} \
                 --sample=${SAMPLE_NAME} \
                 --localcores=${NCPUS} \
                 --localmem=${RAM_MEMORY}
#done
