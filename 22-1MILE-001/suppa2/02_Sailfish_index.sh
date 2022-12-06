#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=ivybridge
#SBATCH --job-name=sailfish_index
#SBATCH --cpus-per-task=4
#SBATCH --mem=30G
#SBATCH --time=24:00:00
#SBATCH --output=%j.out

NCPU=4
ref=/datastore/NGSF001/analysis/references/mouse/mm10/mm10.fa
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/suppa2_analysis/tpm
sailfish=/datastore/NGSF001/software/tools/SailfishBeta-0.10.0_CentOS5/bin

./sailfish index -t ${ref} -o ${OUTDIR} -p ${NCPU}
