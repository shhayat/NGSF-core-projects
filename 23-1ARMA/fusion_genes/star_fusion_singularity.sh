#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=80G
#SBATCH --time=06:00:00
#SBATCH --output=%j.out

module load singularity/3.9.2

singularity exec -e -B `pwd` -B /path/to/ctat_genome_lib_build_dir \
        star-fusion-v$version.simg \
        STAR-Fusion \
        --left_fq reads_1.fq.gz \
        --right_fq reads_2.fq.gz \
        --genome_lib_dir /path/to/ctat_genome_lib_build_dir \
        -O StarFusionOut \
        --FusionInspector validate \
        --examine_coding_effect \
