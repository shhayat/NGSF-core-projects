#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=8
#SBATCH --time=03:00:00
#SBATCH --mem=80G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

#activate star-fusion to use STAR version 2.7.10b
source /globalhome/hxo752/HPC/.bashrc
conda activate star-fusion

GTF=/datastore/NGSF001/analysis/references/dog/CanFam3.1/Canis_lupus_familiaris.ROS_Cfam_1.0.109.gtf
GENOME=/datastore/NGSF001/analysis/references/dog/CanFam3.1/Canis_lupus_familiaris.ROS_Cfam_1.0.dna.toplevel.fa
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/indices

NCPU=8

mkdir -p $OUTDIR
cd ${OUTDIR}

STAR --runThreadN ${NCPU} \
     --runMode genomeGenerate \
     --genomeDir indices \
     --genomeFastaFiles ${GENOME}/genome.fa \
     --sjdbGTFfile ${GTF} \
     --sjdbOverhang 99
