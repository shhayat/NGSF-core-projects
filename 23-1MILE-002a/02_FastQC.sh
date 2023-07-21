#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=fastqc
#SBATCH --ntasks=1
#BATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=5G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

module load fastqc

OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002a/analysis
mkdir -p ${OUTDIR}/fastqc_for_23-1MILE-002a_and_23-1MILE-002_with_umi_header
mkdir -p ${OUTDIR}/fastqc_for_23-1MILE-002a

fq1=$1; shift
fq2=$1;
fastqc -o ${OUTDIR}/fastqc_for_23-1MILE-002a_and_23-1MILE-002_with_umi_header --extract ${fq1}
fastqc -o ${OUTDIR}/fastqc_for_23-1MILE-002a_and_23-1MILE-002_with_umi_header --extract ${fq2}

fastqc -o ${OUTDIR}/fastqc_for_23-1MILE-002a --extract ${fq1}
fastqc -o ${OUTDIR}/fastqc_for_23-1MILE-002a --extract ${fq2}

