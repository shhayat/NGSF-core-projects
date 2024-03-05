#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=fastp
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=02:00:00
#SBATCH --mem=6G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

source $HOME/bashrc
conda activate trimmomatic

DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SCWI-001/Additional_Study/fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SCWI-001/Additional_Study/fastq_trimmed

trimmomatic SE \
          -phred33 input.fq.gz output.fq.gz \
          ILLUMINACLIP:TruSeq3-SE:2:30:10 \
          LEADING:3 \
          TRAILING:3 \
          SLIDINGWINDOW:4:15 \
          MINLEN:36
#mkdir -p ${OUTDIR}

#for i in $DATA/SRR*.fastq.gz
#do
     #   path="${i%.fastq*}";
    #    sample_name=${path##*/};
   
   #     fastp -i ${DATA}/${sample_name}.fastq.gz \
  #            -o ${OUTDIR}/${sample_name}.fastq.gz \
 #             -h ${OUTDIR}/${sample_name}.fastp.html
#done

wait

module load fastqc
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SCWI-001/Additional_Study/fastq_trimmed
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SCWI-001/Additional_Study/analysis/fastqc_trimmed

mkdir -p ${OUTDIR}

for fq in $DATA/SRR*.fastq.gz
do
   fastqc -o ${OUTDIR} --extract ${fq}
   
done 

wait 

cd /globalhome/hxo752/HPC/tools/
multiqc ${OUTDIR}/*_fastqc.zip -o ${OUTDIR}
