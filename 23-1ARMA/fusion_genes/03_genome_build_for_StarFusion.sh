#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=2
#SBATCH --time=24:00:00
#SBATCH --mem=80G
#SBATCH --output=%j.out

#module load perl/5.30.2 
module load star/2.7.9a 
module load blast
export /globalhome/hxo752/HPC/tools/hmmer
/globalhome/hxo752/HPC/anaconda3/condabin/conda activate dfam
STAR_FUSION_HOME="/globalhome/hxo752/HPC/tools/STAR-Fusion"

OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/indices_for_star_fusion
GTF=/datastore/NGSF001/analysis/references/iGenomes/Dog/Canis_familiaris/Ensembl/CanFam3.1/Annotation/Genes/genes.gtf
GENOME=/datastore/NGSF001/analysis/references/iGenomes/Dog/Canis_familiaris/Ensembl/CanFam3.1/Sequence/WholeGenomeFasta/genome.fa

#https://github.com/STAR-Fusion/STAR-Fusion/blob/master/Docker/Dockerfile
${STAR_FUSION_HOME}/ctat-genome-lib-builder/prep_genome_lib.pl --genome_fa ${GENOME} \
                                                               --gtf ${GTF} \
                                                               --CPU 2 \
                                                               --output_dir ${OUTDIR}
