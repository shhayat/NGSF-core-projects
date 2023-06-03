#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=2
#SBATCH --time=24:00:00
#SBATCH --mem=80G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module load perl/5.30.2 

genome-lib-builder=/globalhome/hxo752/HPC/tools/ctat-genome-lib-builder

OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/indices-star-fusion
GTF=/datastore/NGSF001/analysis/references/iGenomes/Dog/Canis_familiaris/Ensembl/CanFam3.1/Annotation/Genes/genes.gtf
GENOME=/datastore/NGSF001/analysis/references/iGenomes/Dog/Canis_familiaris/Ensembl/CanFam3.1/Sequence/WholeGenomeFasta/genome.fa

perl ${genome-lib-builder}/prep_genome_lib.pl --genome_fa ${GENOME} \
                                       --gtf ${GTF} \
                                       --dfam_db 'dog' \
                                       --CPU 8 \
                                       --out_dir ${OUTDIR}
