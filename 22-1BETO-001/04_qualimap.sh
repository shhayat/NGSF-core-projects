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

qualimap=/datastore/NGSF001/software/tools/qualimap_v2.2.1
gtf=/datastore/NGSF001/analysis/references/iGenomes/Dog/Canis_familiaris/Ensembl/CanFam3.1/Annotation/Genes/genes.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1BETO-001/analysis/qualimap

${qualimap}/qualimap rnaseq \
    -outdir ${OUTDIR} \
    -a proportional \
    -bam ${bam_file} \
    -p strand-specific-reverse \
    -gtf ${gtf} \
    --java-mem-size=8G
