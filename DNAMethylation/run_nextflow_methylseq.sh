#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=nf
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=01:00:00
#SBATCH --mem=4G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module --force purge
module load nextflow/21.10.3
module load singularity/3.9.2

config_file=$1;
nextflow run nf-core/methylseq -profile singularity -c ${config_file}
nextflow run nf-core/methylseq -profile singularity --input '*_R{1,2}.fastq.gz' --genome GRCh37

#sbatch run_nextflow_methylseq.sh data.config
#nextflow run $NF_CORE_PIPELINES/methylseq/1.6.1/workflow -profile uppmax --input 
#'/sw/courses/epigenomics/DNAmethylation/pipeline_bsseq_data/Sample1_PE_R{1,2}.fastq.gz' 
#--aligner bismark --project g2021025 --genome mm10 --clusterOptions '--reservation g2021025_28'

