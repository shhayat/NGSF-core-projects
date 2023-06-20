#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=80G
#SBATCH --time=40:00:00
#SBATCH --output=%j.out

/globalhome/hxo752/HPC/tools/star-fusion.v1.11.0.simg
singularity exec -e \
/globalhome/hxo752/HPC/tools/star-fusion.v1.11.0.simg \
/usr/local/src/STAR-Fusion/ctat-genome-lib-builder/prep_genome_lib.pl \
--genome_fa ref_genome.fa \
--gtf ref_annot.gtf \
--fusion_annot_lib CTAT_HumanFusionLib.v0.1.0.dat.gz \
--annot_filter_rule AnnotFilterRule.pm \
--pfam_db current \
--dfam_db human \
--human_gencode_filter
