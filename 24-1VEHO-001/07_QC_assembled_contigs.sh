#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=QC
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --time=48:00:00
#SBATCH --mem=40G
#SBATCH --output=/project/anderson/%j.out



quast_tool=/globalhome/hxo752/HPC/tools/quast-quast_5.2.0
OUTDIR=/project/anderson/QC_for_assembled_contigs
REF=/project/anderson/genome/sequence.fasta
GFF=/project/anderson/genome/sequence.gff3
NCPU=10

fq1=$1; shift
fq2=$1; shift
sample_name=$1; shift


${quast_tool}/quast.py 
                       -o ${OUTDIR} \
                       -r ${REF} \
                       -g ${GFF} \
                       -1 ${fq1} \
                       -2 ${fq2} \
                       --threads ${NCPU}
                       
