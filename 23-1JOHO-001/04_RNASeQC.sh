#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=00:20:00
#SBATCH --mem=5G

set -eux

# copy tool to tempdir and give execute permission
cp /datastore/NGSF001/software/src/rnaseqc.v2.4.2.linux ${SLURM_TMPDIR}
chmod u+x ${SLURM_TMPDIR}/rnaseqc.v2.4.2.linux

sample_name=$1; shift
bam_file=$1


#GTF file needs to be modified for running RNASeQC
#run following python code on GTF file
#python collaspe_annotation.py /datastore/NGSF001/analysis/references/mouse/gencode-m32/gencode.vM32.primary_assembly.annotation.gtf /datastore/NGSF001/analysis/references/mouse/gencode-m32/gencode.vM32.primary_assembly.annotation_mod.gtf

GTF=/datastore/NGSF001/analysis/references/mouse/gencode-m32/gencode.vM32.primary_assembly.annotation_mod.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1JOHO-001/analysis/rnaseqc

mkdir -p ${OUTDIR}

${SLURM_TMPDIR}/rnaseqc.v2.4.2.linux ${GTF} \
                        ${bam_file} \
                        ${OUTDIR} \
                        --sample=${sample_name}
