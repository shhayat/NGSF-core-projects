#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=QC
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=10:00:00
#SBATCH --mem=40G
#SBATCH --output=/project/anderson/%j.out

quast_tool=/globalhome/hxo752/HPC/tools/quast-quast_5.2.0
OUTDIR=/project/anderson/QC_for_assembled_contigs
REF=/project/anderson/genome/sequence.fasta
GFF=/project/anderson/genome/sequence.gff3
NCPU=2

contig=$1; shift
sample_name=$1; shift
outdir_info=$1

mkdir -p ${OUTDIR}/${outdir_info}/${sample_name}

${quast_tool}/quast.py ${contig} \
                       -o ${OUTDIR}/${outdir_info}/${sample_name} \
                       -r ${REF} \
                       -g ${GFF} \
                       --threads ${NCPU}
                       
