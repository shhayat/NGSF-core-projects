#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=annotation
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=20:00:00
#SBATCH --mem=10G
#SBATCH --output=/project/anderson/%j.out

module load perl/5.36.1
prokka=/globalhome/hxo752/HPC/tools/prokka/bin
OUTDIR=/project/anderson/assembly_annotation

contigs=$1; shift
sample_name=$1

mkdir -p ${OUTDIR}

${prokka}/prokka --compliant \
       --mincontiglen 200 \
       --outdir ${OUTDIR}/${sample_name} \
       ${contigs}
       
       
