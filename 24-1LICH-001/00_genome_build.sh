#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=8
#SBATCH --time=08:00:00
#SBATCH --mem=80G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module load star/2.7.9a 

GENOME=/globalhome/hxo752/HPC/tools/IMAPR/reference/GRCh38.d1.vd1.fa
GTF=/globalhome/hxo752/HPC/tools/IMAPR/reference/gencode.v36.annotation.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/24-1LICH-001/analysis/
GENOME_FOLDER_NAME="GRCh38.d1.vd1_star_genomebuild"

NCPU=8

mkdir -p $OUTDIR
cd ${OUTDIR}

STAR --runThreadN ${NCPU} \
     --runMode genomeGenerate \
     --genomeDir ${GENOME_FOLDER_NAME} \
     --genomeFastaFiles ${GENOME} \
     --sjdbGTFfile ${GTF} \
     --sjdbOverhang 99
