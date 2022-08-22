#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=nf_chipseq
#SBATCH --cpus-per-task=20
#SBATCH --mem=80G
#SBATCH --time=04:00:00
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

#there was environment problem while installing rmats with conda. 
#For fixing this issue conda env "rMATS" was created 
#./globalhome/hxo752/HPC/anaconda3/condabin/conda create -n rMATS -c bioconda rMATS then go to path /globalhome/hxo752/HPC/anaconda3/envs/rMATS/bin and run commands

rmat=/globalhome/hxo752/HPC/anaconda3/envs/rMATS/bin
index=/datastore/NGSF001/analysis/indices/rat/Rnor_6.0/star/2.5.1b/
GTF=/datastore/NGSF001/analysis/references/rat/Rnor_6.0/ncbi-genomes-2020-10-30/GCF_000001895.5_Rnor_6.0/GCF_000001895.5_Rnor_6.0_genomic.gtf
DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-002
mkdir -p ${DIR}/rmat_analysis
NCPU=4

mkdir ${SLRUM_TMPDIR}/rmat_tmp
python ${rmat}/rmats.py --s1 group1_bam_files.txt \
                        --s2 group2_bam_files.txt \
                        --gtf ${GTF} \
                        --bi ${index} \
                        -t paired \
                        --readLength 140 \
                        --nthread $NCPU \
                        --od ${DIR}/rmat_analysis \
                        --tmp ${SLRUM_TMPDIR}/rmat_tmp
