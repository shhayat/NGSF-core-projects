#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=cellranger-count
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=24:00:00
#SBATCH --mem=128G
#SBATCH  --output=%j.out


export PATH=/globalhome/hxo752/HPC/tools/cellranger-7.1.0/bin:$PATH

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANFA-001/analysis/count_files/
OUTPUT=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANFA-001/analysis

sample_info=$1; shift
comparision=$1;

mkdir -p ${OUTPUT}/agreggate/${comparision}
cd ${OUTPUT}/agreggate/${comparision}

/globalhome/hxo752/HPC/tools/cellranger-7.1.0/bin/cellranger aggr --id="agreggate" \
                                                                  --csv=${sample_info}
