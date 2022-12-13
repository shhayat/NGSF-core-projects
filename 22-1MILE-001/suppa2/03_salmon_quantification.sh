#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=salmon_tpm
#SBATCH --ntasks=1
#BATCH --cpus-per-task=8
#SBATCH --time=08:00:00
#SBATCH --mem=185G
#SBATCH --output=%j.out

index=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/suppa2_analysis/tpm/index/mm10_index
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/suppa2_analysis/tpm/tpm
sample_name=$1; shift
fq1=$2; shift
fq2=$3;

NCPU=8
$salmon/salmon quant -i mm10_index \
             -l A \
             -1 ${fq1} \
             -2 ${fq2} \
             -p $NCPU \
             --validateMappings \
             -o $OUTDIR/${sample_name}_quant
