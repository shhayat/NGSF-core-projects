#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=15
#SBATCH --time=03:00:00
#SBATCH --mem=80G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module load star/2.7.9a 


GENOME=/datastore/NGSF001/analysis/references/iGenomes/Rat/Rattus_norvegicus/Ensembl/Rnor_6.0/Sequence/WholeGenomeFasta/genome.fa
GTF=/datastore/NGSF001/analysis/references/iGenomes/Rat/Rattus_norvegicus/Ensembl/Rnor_6.0/Annotation/Genes/genes.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1CHXI-001/analysis/

NCPU=8

mkdir -p $OUTDIR
cd ${OUTDIR}

STAR --runThreadN ${NCPU} \
     --runMode genomeGenerate \
     --genomeDir star_2.7.9a_Rnor_6.0 \
     --genomeFastaFiles ${GENOME} \
     --sjdbGTFfile ${GTF} \
     --sjdbOverhang 99
