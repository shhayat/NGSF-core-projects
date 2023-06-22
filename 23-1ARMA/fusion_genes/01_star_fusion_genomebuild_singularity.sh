#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=180G
#SBATCH --time=24:00:00
#SBATCH --output=%j.out

module load singularity/3.9.2

GTF=/globalhome/hxo752/HPC/ngsf_git_repos/CanFam3.1/Canis_lupus_familiaris.ROS_Cfam_1.0.109.gtf
GENOME=/globalhome/hxo752/HPC/ngsf_git_repos/CanFam3.1/Canis_lupus_familiaris.ROS_Cfam_1.0.dna.toplevel.fa
DFAM_DATABASE=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/Dfam/canis_lupus_familiaris_dfam.hmm
PFAM_DATABASE=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/Pfam/Pfam-A.hmm

singularity exec -e /globalhome/hxo752/HPC/tools/star-fusion.v1.11.0.simg \
                    /globalhome/hxo752/HPC/tools/STAR-Fusion-v1.11.0/ctat-genome-lib-builder/prep_genome_lib.pl \
                --genome_fa ${GENOME} \
                --gtf ${GTF} \
                --dfam_db ${DFAM_DATABASE} \
                --pfam_db ${PFAM_DATABASE} \
                --CPU 4
                 
