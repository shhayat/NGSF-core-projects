#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=80G
#SBATCH --time=40:00:00
#SBATCH --output=%j.out

module load apptainer/1.1

singularity exec -e /globalhome/hxo752/HPC/tools/star-fusion.v1.11.0.simg \
                    /globalhome/hxo752/HPC/tools/STAR-Fusion-v1.11.0/ctat-genome-lib-builder/prep_genome_lib.pl \
                 --genome_fa ref_genome.fa \
                 --gtf ref_annot.gtf \
                 
