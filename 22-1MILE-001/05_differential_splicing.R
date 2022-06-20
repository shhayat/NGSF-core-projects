#!/bin/bash

#SBATCH --job-name=differential_splicing
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module load r/4.1.2

OUTDIR=""
mkdir ${OUTDIR} 
cp /mnt/NGSF001/analysis/references/mouse/mm10/leafcutter/m10.exon.txt.gz ${SLURM_TMPDIR}

Rscript ~/envs/leafcutter/scripts/leafcutter_ds.R -o  --num_threads 4 -g 3 -i 3 -e ${SLURM_TMPDIR}/m10.exon.txt.gz ../junction/CTRLvsA1_perind_numers.counts.gz ../junction/groups_file.txt
