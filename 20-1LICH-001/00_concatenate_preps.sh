#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=markdup_add_RG
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=2:30:00
#SBATCH --mem=64G
#SBATCH  --output=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/markdup_add_RG.out
set -eux

fq
fastq_file="/datastore/APOBECMiSeq/NGS Core Files/NGS Core 2020-1LICH-001/fastq"


for i in $fastq_file/
