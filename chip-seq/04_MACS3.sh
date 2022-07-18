#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=macs3
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --mem=20G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out


#cd /globalhome/hxo752/HPC/anaconda3/bin
cd /globalhome/hxo752/HPC/.local/lib/python3.7/site-packages

OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/peakcall1
controlBAM=$1; shift
treatBAM=$1; shift
sample_name=$1

mkdir -p ${OUTDIR}/${sample_name}

./macs3 callpeak \
		--treatment ${treatBAM} \
                --control ${controlBAM} \
                --format BAM \
                --gsize hs \
                --name ${sample_name} -B \
                --pvalue 5e-2 \
                --outdir ${OUTDIR}/${sample_name}/ && \
                sort -k8,8nr ${OUTDIR}/${sample_name}/${sample_name}_peaks.narrowPeak > ${OUTDIR}/${sample_name}/${sample_name}_peaks.sorted.narrowPeak # --qvalue 0.01 \
