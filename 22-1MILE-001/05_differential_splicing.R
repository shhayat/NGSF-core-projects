#!/bin/bash

#SBATCH --job-name=differential_splicing
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module load r/4.1.2

OUTDIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/analysis/differntial_splicing"
mkdir -p ${OUTDIR} 

cp /datastore/NGSF001/analysis/references/mouse/mm10/leafcutter/m10.exon.txt.gz ${SLURM_TMPDIR}

#Rscript /globalhome/hxo752/HPC/tools/leafcutter/scripts/leafcutter_ds.R -o ${OUTDIR} --num_threads 4 -g 3 -i 3 -e ${SLURM_TMPDIR}/m10.exon.txt.gz /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/analysis/intron_clustering/leafcutter_perind_numers.counts.gz /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/groups_file.txt

Rscript /globalhome/hxo752/HPC/tools/leafcutter/scripts/leafcutter_ds.R -o /Users/shahina/Projects/22-1MILE-001 --num_threads 4 -g 3 -i 3 -e /Users/shahina/Projects/22-1MILE-001/m10.exon.txt.gz /Users/shahina/Projects/22-1MILE-001/leafcutter_perind_numers.counts.gz /Users/shahina/Projects/22-1MILE-001/groups_file.txt

