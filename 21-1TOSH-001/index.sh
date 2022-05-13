#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=1:00:00
#SBATCH --mem=6G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

#loading required modules
module load star

NCPU = 4
GENOME=/datastore/NGSF001/analysis/references/bison/jhered/esab003/
REF=/datastore/NGSF001/analysis/references/bison/jhered/esab003/sequence.fasta
$OUT_TMP=/globalhome/hxo752/HPC

STAR --runMode genomeGenerate --genomeDir $GENOME --genomeFastaFiles $REF --outTmpDir $OUT_TMP --runThreadN $NCPU
