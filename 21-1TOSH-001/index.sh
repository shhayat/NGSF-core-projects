#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=1:00:00
#SBATCH --mem=60G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

#loading required modules
module load star/2.7.9a 

rsync -avzP /datastore/NGSF001/analysis/references/bison/jhered/esab003/sequence.fasta ${SLURM_TMPDIR}/
#rsync -avzP /datastore/NGSF001/analysis/references/bison/jhered/esab003/bison.liftoff.chromosomes.gff ${SLURM_TMPDIR}/
rsync -avzP /globalhome/hxo752/HPC/bison.liftoff.gtf ${SLURM_TMPDIR}/
mkdir -p ${SLURM_TMPDIR}/star-2.7.9a

#GENOME=/datastore/NGSF001/analysis/references/bison/jhered/esab003/


REF=${SLURM_TMPDIR}/sequence.fasta



STAR --runThreadN 8 \
    --runMode genomeGenerate \
    --genomeDir ${SLURM_TMPDIR}/star-index-2.7.9a \
    --genomeFastaFiles $REF \
    --sjdbGTFfile ${SLURM_TMPDIR}/bison.liftoff.gtf
    
#--sjdbGTFfile ${SLURM_TMPDIR}/bison.liftoff.chromosomes.gff

rsync -rvzP ${SLURM_TMPDIR}/star-index-2.7.9a /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001/indices
