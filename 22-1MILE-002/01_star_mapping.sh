#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=mapping
#SBATCH --ntasks=1
#BATCH --cpus-per-task=8
#SBATCH --time=03:00:00
#SBATCH --mem=20G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

NCPUS=8
#work adapted from https://github.com/ngsf-usask/scripts/tree/main/RNAseq/22-1MILE-002
INDEX=
#star-twopass
STAR --runMode alignReads \
    --runThreadN $NCPUS \
    --genomeDir $INDEX \
    --readFilesIn $(echo "${SLURM_TMPDIR}/${R1%.*}") $(echo "${SLURM_TMPDIR}/${R2%.*}") \
    --twopassMode Basic \
    --outSAMstrandField intronMotif \
    --outSAMtype BAM Unsorted
