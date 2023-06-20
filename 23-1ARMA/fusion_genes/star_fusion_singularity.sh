#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=80G
#SBATCH --time=06:00:00
#SBATCH --output=%j.out

module load apptainer/1.1.3
GTF=/datastore/NGSF001/analysis/references/dog/CanFam3.1/Canis_lupus_familiaris.ROS_Cfam_1.0.109.gtf
GENOME=/datastore/NGSF001/analysis/references/dog/CanFam3.1/Canis_lupus_familiaris.ROS_Cfam_1.0.dna.toplevel.fa
#DFAM_DATABASE=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/Pfam/Pfam-A.hmm
DFAM_DATABASE=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/Dfam/canis_lupus_familiaris_dfam.hmm
PFAM_DATABASE=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/Pfam/Pfam-A.hmm

apptainer exec -e /globalhome/hxo752/HPC/tools/star-fusion.v1.11.0.simg \
                    /globalhome/hxo752/HPC/tools/STAR-Fusion-v1.11.0/ctat-genome-lib-builder/prep_genome_lib.pl \
                --genome_fa ${GENOME} \
                --gtf ${GTF} \
                --dfam_db ${DFAM_DATABASE} \
                --pfam_db ${PFAM_DATABASE} \
                --CPU 4
                 
