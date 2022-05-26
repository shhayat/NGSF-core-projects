#!/bin/bash

#SBATCH --job-name=fastqc
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=1:25:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

module load fastqc
DATA=
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/new_proj

OUTDIR=/data/labs/bioinformatics_lab/processed/RNAseq/mazloum_nayef/KIF4a_knockout/FastQC_and_MultiQC
DIR=/data/labs/bioinformatics_lab/shared/RNASeq/mazloum_nayef/KIF4a_knockout
mkdir -p $RESULT_FOLDER


for fastq in $DATA/*.fastq.gz
do
     echo "fastqc -o $RESULT_FOLDER --extract ${fastq}" >> $DIR/run_fastqc.sh
done

echo "multiqc $RESULT_FOLDER/*_fastqc.zip" -o  $RESULT_FOLDER >> $DIR/run_mutiqc.sh
