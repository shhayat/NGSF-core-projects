#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=macs3
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=5:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out


#cd /globalhome/hxo752/HPC/anaconda3/bin
cd /globalhome/hxo752/HPC/.local/lib/python3.7/site-packages

OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/peakcall
controlBAM=$1; shift
treatBAM=$1; shift
sample_name=$1

mkdir -p ${OUTDIR}/${sample_name}

macs3 callpeak \
		--treatment ${treatBAM} \
                --control ${controlBAM} \
                --format BAM \
		--gsize hs \
		--keep-dup all \
                --name ${sample_name} -B \
                --pvalue 5e-2 \
                --outdir ${OUTDIR}/${sample_name}/ && \
                sort -k8,8nr ${OUTDIR}/${sample_name}/${sample_name}_peaks.narrowPeak > ${OUTDIR}/${sample_name}/${sample_name}_peaks.sorted.narrowPeak 
		# --qvalue 0.01 \

#extracting most relevant columns
cut -f 1-3 ${OUTDIR}/${sample_name}/${sample_name}_peaks.sorted.narrowPeak > ${OUTDIR}/${sample_name}/${sample_name}_peaks.sorted.narrowPeak_selected_columns.bed
