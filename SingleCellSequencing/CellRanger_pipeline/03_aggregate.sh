#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=cellranger-count
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=24:00:00
#SBATCH --mem=128G
#SBATCH  --output=%j.out

#source /globalhome/hxo752/HPC/cell_ranger_env/bin/activate

export PATH=/globalhome/hxo752/HPC/tools/cellranger-7.1.0/bin:$PATH

OUTPUT=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/analysis

mkdir -p ${OUTPUT}/agreggate
cd ${OUTPUT}

CSV_FILE=$1;
/globalhome/hxo752/HPC/tools/cellranger-7.1.0/bin/cellranger aggr --id="aggregated" \
                                                                  --csv=${CSV_FILE}
