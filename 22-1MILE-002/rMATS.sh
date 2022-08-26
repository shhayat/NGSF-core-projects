#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=rMATS
#SBATCH --cpus-per-task=10
#SBATCH --mem=80G
#SBATCH --time=24:00:00
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

#there was environment problem while installing rmats with conda. 
#For fixing this issue conda env "rMATS" was created 
#./globalhome/hxo752/HPC/anaconda3/condabin/conda create -n rMATS -c bioconda rMATS then go to path /globalhome/hxo752/HPC/anaconda3/envs/rMATS/bin and run commands

rmat=/globalhome/hxo752/HPC/anaconda3/envs/rMATS/bin
#index=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-002/star-index
GTF=/datastore/NGSF001/analysis/references/rat/Rnor_6.0/ncbi-genomes-2020-10-30/GCF_000001895.5_Rnor_6.0/GCF_000001895.5_Rnor_6.0_genomic.gtf
DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-002
mkdir -p ${DIR}/rmat_analysis
NCPU=40
#star=/datastore/NGSF001/software/tools/STAR-2.7.4a/bin/Linux_x86_64

#module load cellranger
#PATH=/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/cellranger/2.1.0/STAR/5dda596/:$PATH
#source $HOME/.bashrc
#conda activate rMATS

${star}/STAR
mkdir -p ${DIR}/rmat_analysis/tmp
${rmat}/python ${rmat}/rmats.py --b1 $DIR/group1_bam_files.txt \
                        --b2 $DIR/group2_bam_files.txt \
                        --gtf ${GTF} \
                        -t paired \
                        --readLength 141 \
                        --nthread $NCPU \
                        --od ${DIR}/rmat_analysis \
                        --tmp ${DIR}/rmat_analysis/tmp
                        

