#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=trim
#SBATCH --ntasks=1
#BATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=5G
#SBATCH --output=/project/anderson/%j.out

fq1=$1; shift
fq2=$1; shift

NCPU=1

OUTDIR=/project/anderson/trimmed_fastq
mkdir -p $OUTDIR
cd $OUTDIR

trim_galore=/$HOME/venvs/trim-glore/TrimGalore-0.6.10
${trim_galore}/trim_galore \
                           --paired ${fq1} ${fq2} \
                           --cores ${NCPU} \
                           --illumina
