#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=ivybridge
#SBATCH --job-name=FastqToSam
#SBATCH --cpus-per-task=1
#SBATCH --mem=30G
#SBATCH --time=24:00:00
#SBATCH --output=%j.out

#/datastore/NGSF001/projects/2021/21-1MILE-001/alignment/star
NCPU=1
module load picard/2.23.3 
fastq_path=/datastore/NGSF001/projects/2021/21-1MILE-001/fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/Piranha

java -Xmx30G -XX:ParallelGCThreads=$NCPU -jar $EBROOTPICARD/picard.jar FastqToSam \
    F1=$fastq_path/R2100080_S1_R1_001.fastq.gz \
    F2=$fastq_path/R2100080_S1_R2_001.fastq.gz \
    O=$OUTDIR/R2100080_fastqtosam.bam \
    SM=R2100080 \
    RG=rg0013

    
