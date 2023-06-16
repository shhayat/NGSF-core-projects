#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=80G
#SBATCH --time=40:00:00
#SBATCH --output=%j.out

source /globalhome/hxo752/HPC/.bashrc
#conda activate star-fusion
conda activate ame
#OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/CanFamDB
OUTDIR=/globalhome/hxo752/HPC/CanFamDB
GTF=/datastore/NGSF001/analysis/references/iGenomes/Dog/Canis_familiaris/Ensembl/CanFam3.1/Annotation/Genes/genes.gtf
GENOME=/datastore/NGSF001/analysis/references/iGenomes/Dog/Canis_familiaris/Ensembl/CanFam3.1/Sequence/WholeGenomeFasta/genome.fa
DFAM_DATABASE=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/Pfam-A.hmm

mkdir -p ${OUTDIR}
#https://github-wiki-see.page/m/NCIP/ctat-genome-lib-builder/wiki/Building-a-Custom-CTAT-Genome-Lib
#https://github.com/STAR-Fusion/STAR-Fusion/blob/master/Docker/Dockerfile
prep_genome_lib.pl --genome_fa ${GENOME} \
                       --gtf ${GTF} \
                       --dfam_db ${DFAM_DATABASE} \
                       --CPU 4 \
                       --output_dir ${OUTDIR}
