#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=sailfish_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=1
#SBATCH --time=08:00:00
#SBATCH --mem=185G
#SBATCH --output=%j.out

NCPU=1
ref=/datastore/NGSF001/analysis/references/mouse/mm10/mm10.fa
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/suppa2_analysis/tpm/index
sailfish=/datastore/NGSF001/software/tools/SailfishBeta-0.10.0_CentOS5/bin/

${sailfish}/sailfish index -t ${ref} -o ${OUTDIR} -p ${NCPU}
