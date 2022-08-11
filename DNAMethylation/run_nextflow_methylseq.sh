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
module load nextflow/22.04.3
module load singularity/3.9.2

config_file=$1;
nextflow run nf-core/methylseq -profile data,singularity -c ${config_file}

#sbatch run_nextflow_methylseq.sh data.config
