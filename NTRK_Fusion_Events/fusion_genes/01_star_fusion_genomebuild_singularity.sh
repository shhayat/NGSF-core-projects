#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=80G
#SBATCH --time=24:00:00
#SBATCH --output=%j.out

module load singularity/3.9.2

#latest annotation file
GTF=/datastore/NGSF001/analysis/references/ROS_Cfam_1.0/Canis_lupus_familiaris.ROS_Cfam_1.0.109.gtf
#latest genome
GENOME=/datastore/NGSF001/analysis/references/ROS_Cfam_1.0/Canis_lupus_familiaris.ROS_Cfam_1.0.dna.toplevel.fa
#old annotations which was modified to make it compatible with prep_genome_lib.pl. The modified file is called genomic_1.gtf which was passed to prep_genome_lib.pl script
#GTF=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/Cfam3.1_NCBI/genomic.gtf
#GTF_old=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/Cfam3.1_NCBI/genomic_1.gtf
#old reference genome
#GENOME_oldref=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/Cfam3.1_NCBI/GCF_000002285.3_CanFam3.1_genomic.fna

DFAM_DATABASE=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/Dfam/canis_lupus_familiaris_dfam.hmm
PFAM_DATABASE=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/Pfam/Pfam-A.hmm

#nextflow pipline for building reference genome
singularity exec -e /globalhome/hxo752/HPC/tools/star-fusion.v1.11.0.simg \
                    /globalhome/hxo752/HPC/tools/STAR-Fusion-v1.11.0/ctat-genome-lib-builder/prep_genome_lib.pl \
                --genome_fa ${GENOME} \
                --gtf ${GTF} \
                --dfam_db ${DFAM_DATABASE} \
                --pfam_db ${PFAM_DATABASE} \
                --CPU 4
wait

#mv ctat_genome_lib_build_dir ctat_genome_lib_build_dir_ROS_Cfam_1.0
mv ctat_genome_lib_build_dir ctat_genome_lib_build_dir_Cfam3.1_NCBI
