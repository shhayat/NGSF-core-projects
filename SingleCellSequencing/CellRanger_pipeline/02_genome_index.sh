#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=10
#SBATCH --time=03:00:00
#SBATCH --mem=80G
#SBATCH --output=%j.out

module load python/3.9
cellranger=/datastore/NGSF001/software/tools/cellranger-7.1.0/bin
GENOME=/datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa
GTF=/datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Annotation/Genes/genes.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/analysis/indices

NCPU=10

mkdir -p $OUTDIR
cd ${OUTDIR}

${cellranger}/cellranger mkref \
         --nthreads=${NCPUS} \
         --genome=${OUTDIR} \
         --fasta=${GENOME} \
         --genes=${GTF}
