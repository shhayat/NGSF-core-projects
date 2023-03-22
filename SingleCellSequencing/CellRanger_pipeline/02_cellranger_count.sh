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

NCPUS=16
RAM_MEMORY=128

FASTQS=/datastore/NGSF001/projects/23-1ANLE-001/Analysis/fastq
REF=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/CellRanger_pipeline/refdata-gex-GRCh38-2020-A/
OUTPUT=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/analysis/count_files
mkdir -p ${OUTPUT}
cd ${OUTPUT}
for i in $(seq -w 1 2);
do
SAMPLE_NAME="R230000${i}"
/globalhome/hxo752/HPC/tools/cellranger-7.1.0/bin/cellranger count --id=${SAMPLE_NAME} \
                 --transcriptome=${REF} \
                 --fastqs=${FASTQS} \
                 --sample=${SAMPLE_NAME} \
                 --localcores=${NCPUS} \
                 --localmem=${RAM_MEMORY}
done
