#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=idr
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out


#https://github.com/hbctraining/Intro-to-ChIPseq/blob/master/lessons/07_handling-replicates-idr.md
#Combining replicates to only get the highly reproducible peaks using the IDR method

peaks=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/peakcall
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/IDR

files=$1;

mkdir -p $OUTDIR
cd /globalhome/hxo752/HPC/anaconda3/bin

./idr --samples ${files} \
    --rank p.value \
    --output-file ${OUTDIR}/idr.bed \
    --plot \
    --log-output-file ${OUTDIR}/idr.log \
    --verbose



