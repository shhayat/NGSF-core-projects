#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=salmon_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=1
#SBATCH --time=08:00:00
#SBATCH --mem=185G
#SBATCH --output=%j.out


salmon=/datastore/NGSF001/software/tools/salmon-1.9.0_linux_x86_64/bin
GENOME=/datastore/NGSF001/analysis/references/mouse/mm10/mm10.fa
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/suppa2_analysis/tpm/index
$salmon/salmon index -t ${GENOME} -i ${OUTDIR}/athal_index
