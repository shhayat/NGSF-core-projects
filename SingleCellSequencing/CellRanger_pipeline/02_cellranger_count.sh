#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=cellranger-count
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=24:00:00
#SBATCH --mem=128G
#SBATCH  --output=%j.out

#source /globalhome/hxo752/HPC/cell_ranger_env/bin/activate

export PATH=/globalhome/hxo752/HPC/tools/cellranger-7.1.0/bin:$PATH

#FASTQS=/datastore/NGSF001/datasets/singlecell/Brain_Tumor_3p_fastqs

REF=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/CellRanger_pipeline/refdata-gex-GRCh38-2020-A/
OUTPUT=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/analysis/count_files

NCPUS=16
RAM_MEMORY=128
#OUTPUT_FOLDER="Brain_Tumor_3p_separate_lanes"
#SAMPLE_NAME="Brain_Tumor_3p"
SAMPLE_NAME=1;
mkdir -p ${OUTPUT}/${SAMPLE_NAME}
cd ${OUTPUT}/${SAMPLE_NAME}

/globalhome/hxo752/HPC/tools/cellranger-7.1.0/bin/cellranger count --id=${OUTPUT} \
                 --transcriptome=${REF} \
                 --fastqs=${FASTQS} \
                 --sample=${SAMPLE_NAME} \
                 --localcores=${NCPUS} \
                 --localmem=${RAM_MEMORY}
