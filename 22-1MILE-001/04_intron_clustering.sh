#!/bin/bash

#SBATCH --job-name=intron_clustering
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module load python/3.8.10

JUNCT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/analysis/bam_to_junct
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/analysis/intron_clustering

mkdir -p ${OUTDIR}

python /globalhome/hxo752/HPC/tools/leafcutter/clustering/leafcutter_cluster_regtools.py -j ${JUNCT_DIR}/juncfiles.txt -m 50 -l 500000

mv /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/D22* ${OUTDIR}
mv /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/leaf* ${OUTDIR}
