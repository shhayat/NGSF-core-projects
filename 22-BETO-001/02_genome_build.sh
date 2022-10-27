#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=16
#SBATCH --time=03:00:00
#SBATCH --mem=80G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module load star/2.7.9a 


GENOME=/datastore/NGSF001/analysis/references/iGenomes/Dog/Canis_familiaris/Ensembl/CanFam3.1/Sequence/WholeGenomeFasta
GTF=/datastore/NGSF001/analysis/references/iGenomes/Dog/Canis_familiaris/Ensembl/CanFam3.1/Annotation/Genes/genes.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-BETO-001/indices

NCPU=16

mkdir -p $OUTDIR
cd ${OUTDIR}

${star}/STAR --runThreadN ${NCPU} \
     --runMode genomeGenerate \
     --genomeDir star-index \
     --genomeFastaFiles ${GENOME}/genome.fa \
     --sjdbGTFfile ${GTF} \
     --sjdbOverhang 99
