#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=10
#SBATCH --time=03:00:00
#SBATCH --mem=80G
#SBATCH --output=%j.out
	
set -eux

export PATH=/globalhome/hxo752/HPC/tools/cellranger-7.1.0/bin:$PATH
#GENOME=/datastore/NGSF001/analysis/references/ROS_Cfam_1.0/Canis_lupus_familiaris.ROS_Cfam_1.0.dna.toplevel.fa
#GTF=/datastore/NGSF001/analysis/references/ROS_Cfam_1.0/Canis_lupus_familiaris.ROS_Cfam_1.0.109.gtf

#since ROS_Cfam_1.0 annotation file don't have mitochondrial gene information which needs while quality filtering. The mitochondrial gene 
#annotation from CanFam3.1 was added to ROS_Cfam_1.0 annotation file and combinded.gtf was created. Mitochondrial sequence from CanFam3.1 
#also added to ROS_Cfam_1.0 fasta and combined.fasta was generated

GENOME=/datastore/NGSF001/analysis/references/dog/ROS_Cfam_1.0_Ensembl/combined.fa
GTF=/datastore/NGSF001/analysis/references/dog/ROS_Cfam_1.0_Ensembl/combined.gtf
#GENOME=/datastore/NGSF001/analysis/references/CanFam6/GCF_000002285.5_Dog10K_Boxer_Tasha_rna.fna
#GTF=/datastore/NGSF001/analysis/references/CanFam6/GCF_000002285.5_Dog10K_Boxer_Tasha_genomic.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA-002/analysis/
GENOME_FOLDER_NAME="ROS_Cfam_1.0_Ensembl_index"
NCPUS=10
cd ${OUTDIR}

cellranger mkref \
         --nthreads=${NCPUS} \
         --genome=${GENOME_FOLDER_NAME} \
         --fasta=${GENOME} \
         --genes=${GTF}
