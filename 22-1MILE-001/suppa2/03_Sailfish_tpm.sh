#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=sailfish_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=1
#SBATCH --time=02:00:00
#SBATCH --mem=80G
#SBATCH --output=%j.out

OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/suppa2_analysis/tpm/tpm
index=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/suppa2_analysis/tpm
sailfish=/datastore/NGSF001/software/tools/SailfishBeta-0.10.0_CentOS5/bin/

NCPU=1
fq1=
fq2=

${sailfish}/sailfish quant -i ${index} -l "<libtype>" -1 ${fq1} -2 ${fq2} -o ${OUTDIR}
