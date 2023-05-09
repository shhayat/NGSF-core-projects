#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=00:30:00
#SBATCH --mem=5G

set -eux

rnaseqc=/datastore/NGSF001/software/src/

sample_name=$1; shift
bam_file=$1


#GTF file needs to be modified for running RNASeQC
GTF=/datastore/NGSF001/analysis/references/bison/ftp.ensembl.org/pub/release-105/gtf/bison_bison_bison/Bison_bison_bison.Bison_UMD1.0.105.mod.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1TOSH-001/analysis/rnaseqc

mkdir -p ${OUTDIR}

${rnaseqc}/rnaseqc.v2.4.2.linux ${GTF} \
                        ${bam_file} \
                        ${OUTDIR} \
                        --sample=${sample_name}
