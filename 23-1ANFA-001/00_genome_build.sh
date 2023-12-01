#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=10
#SBATCH --time=03:00:00
#SBATCH --mem=80G
#SBATCH --output=%j.out

export PATH=/globalhome/hxo752/HPC/tools/cellranger-7.1.0/bin:$PATH

GENOME=/datastore/NGSF001/analysis/references/iGenomes/Bos_taurus/Ensembl/UMD3.1/Sequence/WholeGenomeFasta/genome.fa
GTF=/datastore/NGSF001/analysis/references/iGenomes/Bos_taurus/Ensembl/UMD3.1/Annotation/Genes/genes.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANFA-001/analysis/Bos_taurus_genome_index
NCPUS=10
mkdir ${OUTDIR}
cd ${OUTDIR}

cellranger mkref \
         --nthreads=${NCPUS} \
         --genome=${GENOME_NAME} \
         --fasta=${GENOME} \
         --genes=${GTF}
