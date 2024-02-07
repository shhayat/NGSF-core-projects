 #!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=10
#SBATCH --time=03:00:00
#SBATCH --mem=80G
#SBATCH --output=%j.out

export PATH=/globalhome/hxo752/HPC/tools/cellranger-7.1.0/bin:$PATH
GENOME=/datastore/NGSF001/analysis/references/ROS_Cfam_1.0/Canis_lupus_familiaris.ROS_Cfam_1.0.dna.toplevel.fa
GTF=/datastore/NGSF001/analysis/references/ROS_Cfam_1.0/Canis_lupus_familiaris.ROS_Cfam_1.0.109.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA-002/analysis/
GENOME_FOLDER_NAME="Canine_index"
NCPUS=10
cd ${OUTDIR}

cellranger mkref \
         --nthreads=${NCPUS} \
         --genome=${GENOME_FOLDER_NAME} \
         --fasta=${GENOME} \
         --genes=${GTF}
