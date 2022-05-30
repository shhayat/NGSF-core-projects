#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=3:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

#loading required modules
module load star/2.7.9a 

OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/depletion_tests/human/indices
mkdir -p ${OUTDIR}
NCPU=4

rsync -avzP /datastore/NGSF001/analysis/references/human/gencode-40/GRCh38.primary_assembly.genome.fa ${SLURM_TMPDIR}/
rsync -avzP /datastore/NGSF001/analysis/references/human/gencode-40/gencode.v40.annotation.gtf ${SLURM_TMPDIR}/

mkdir -p ${SLURM_TMPDIR}/gencode-40
mkdir -p ${OUTDIR}


STAR --runThreadN ${NCPU} \
     --runMode genomeGenerate \
     --genomeDir ${SLURM_TMPDIR}/gencode-40 \
     --genomeFastaFiles ${SLURM_TMPDIR}/GRCh38.primary_assembly.genome.fa
     --sjdbGTFfile ${SLURM_TMPDIR}/gencode.v40.annotation.gtf
    
rsync -rvzP ${SLURM_TMPDIR}/gencode-40 ${OUTDIR}
