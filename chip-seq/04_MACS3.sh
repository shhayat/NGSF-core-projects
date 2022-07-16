#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=macs3
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --mem=20G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out


cd /globalhome/hxo752/HPC/.local/bin/

OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/analysis/peakcall
controlBAM=$1; shift
treatBAM=$1; shift
sample_name=$1

mkdir ${OUTDIR}/${sample_name}

macs3 callpeak  --treatment ${treatBAM} \
                --control ${controlBAM} \
                --format BAM \
                --gsize hs \
                --name ${sample_name} -B \
                --pvalue 1e-3 \
                --outdir ${OUTDIR}/${sample_name} && \
                sort -k8,8nr ${OUTDIR}/${sample_name}/peaks.narrowPeak > ${OUTDIR}/${sample_name}/peaks.sorted.narrowPeak 


# --qvalue 0.01 \
