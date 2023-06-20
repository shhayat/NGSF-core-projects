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

output_dir=

singularity exec -e -B `pwd` -B /path/to/ctat_genome_lib_build_dir \
                /globalhome/hxo752/HPC/tools/star-fusion.v1.11.0.simg \
                STAR-Fusion \
                --left_fq reads_1.fq.gz \
                --right_fq reads_2.fq.gz \
                --genome_lib_dir /path/to/ctat_genome_lib_build_dir \
                -O ${output_dir} \
                --FusionInspector validate \
                --examine_coding_effect \
