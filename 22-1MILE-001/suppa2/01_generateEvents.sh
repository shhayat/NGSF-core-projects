#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=ivybridge
#SBATCH --job-name=suppa2_generate_events
#SBATCH --cpus-per-task=1
#SBATCH --mem=30G
#SBATCH --time=24:00:00
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

SUPPA=/globalhome/hxo752/HPC/anaconda3/envs/suppa/bin
GTF=/datastore/NGSF001/analysis/references/rat/Rnor_6.0/ncbi-genomes-2020-10-30/GCF_000001895.5_Rnor_6.0/GCF_000001895.5_Rnor_6.0_genomic.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2_analysis

${SUPPA}/python ${SUPPA}/suppa.py generateEvents \
                              -i $GTF \ 
                              -o $OUTDIR/events_from_gtf \
                              -f ioe \
                              -e SE SS MX RI FL  
