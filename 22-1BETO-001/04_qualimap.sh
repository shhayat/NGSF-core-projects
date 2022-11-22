#!/bin/bash
#SBATCH --constraint=skylake
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:50:00
#SBATCH --mem=200G

set -eux
sample_name=1; shift
bam_file=$1;

qualimap=/datastore/NGSF001/software/tools/qualimap_v2.2.1
gtf=/datastore/NGSF001/analysis/references/iGenomes/Dog/Canis_familiaris/Ensembl/CanFam3.1/Annotation/Genes/genes.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1BETO-001/analysis/qualimap

${qualimap}/qualimap rnaseq \
    -outdir ${OUTDIR} \
    -oc ${sample_name} \
    -a proportional \
    -bam ${bam_file} \
    -p strand-specific-forward \
    -gtf ${gtf} \
    -pe \
    --java-mem-size=200G
