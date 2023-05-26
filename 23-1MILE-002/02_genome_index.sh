#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=03:00:00
#SBATCH --mem=80G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module load star/2.7.9a 


GENOME=/datastore/NGSF001/analysis/references/iGenomes/Mouse/Mus_musculus/Ensembl/GRCm38/Sequence/WholeGenomeFasta
GTF=/datastore/NGSF001/analysis/references/iGenomes/Mouse/Mus_musculus/Ensembl/GRCm38/Annotation/Genes/genes.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002/analysis

NCPU=8

mkdir -p $OUTDIR
cd ${OUTDIR}

STAR --runThreadN ${NCPU} \
     --runMode genomeGenerate \
     --genomeDir star-index \
     --genomeFastaFiles ${GENOME}/genome.fa \
     --sjdbGTFfile ${GTF} \
     --sjdbOverhang 99
