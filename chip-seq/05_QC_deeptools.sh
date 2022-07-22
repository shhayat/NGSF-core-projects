#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=QC-deeptools
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --mem=20G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module load python/3.7.7
#deeptools
cd /globalhome/hxo752/HPC/.local/lib/python3.7/site-packages/deeptools/

NCPUS=2
OUTDIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis"
bam_files=1;

mkdir ${OUTDIR}/QC/deeptools

python plotFingerprint.py \
            --bamfiles ${bam_files} \
            --extendReads 110  \
            --binSize=1000 \
            --plotFile ${OUTDIR}/QC/deeptools/fingerprint.pdf \
            --labels G1E_TAL1_rep1 G1E_TAL1_rep2 Input_rep1 Input_rep2 \
            -p ${NCPUS} &> ${OUTDIR}/deeptools/fingerprint.log
  
