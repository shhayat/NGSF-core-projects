#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=QC-deeptools
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module load python/3.7.7
#deeptools
cd /globalhome/hxo752/HPC/.local/lib/python3.7/site-packages/deeptools/

DIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis"

idr_bed_file=$1; shift
bam_files=$1;
labels=$1;

NCPU=4

mkdir -p ${DIR}/QC/QC_after_peakcall

multiBamSummary BED-file \
                --BED ${idr_bed_file} \
                --bamfiles ${bam_files} \
                --labels ${labels} \
                --outFileName ${DIR}/QC/QC_after_peakcall/.npz \
                 -p ${NCPU}
