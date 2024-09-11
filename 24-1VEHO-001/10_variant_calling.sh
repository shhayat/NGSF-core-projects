#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=variant_call
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=24:00:00
#SBATCH --mem=200G
#SBATCH --output=/project/anderson/%j.out


source /globalhome/hxo752/HPC/.bashrc
sample_name=$1;
NCPU=20

mtbseq=/globalhome/hxo752/HPC/miniconda/bin
#OUTDIR=/project/anderson/variant_calling
DATA=/project/anderson/trimmed_fastq

#mkdir -p ${OUTDIR}

cd ${DATA}
${mtbseq}/MTBseq --step TBfull \
                 --threads ${NCPU} \
                 --ref ${REF}
                  
#mv GATK_Bam/ ${OUTDIR}
#mv Mpileup/ ${OUTDIR}
#mv Position_Tables/ ${OUTDIR}
#mv Statistics/ ${OUTDIR}
#mv Joint/ ${OUTDIR}
#mv Amend/ ${OUTDIR}
#mv Classification/ ${OUTDIR}
#mv Groups/ ${OUTDIR}
#mv Bam/ ${OUTDIR}


