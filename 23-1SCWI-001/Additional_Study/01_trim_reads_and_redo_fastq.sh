#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=cutadapt_trimmomatic
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=02:00:00
#SBATCH --mem=6G
#SBATCH --output=%j.out
set -eux

#used parameter setting from paper sent by sccot https://www-sciencedirect-com.cyber.usask.ca/science/article/pii/S0092867419301138?via%3Dihub

source $HOME/.bashrc
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SCWI-001/Additional_Study/fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SCWI-001/Additional_Study/fastq_trimmed
OUTDIR1=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SCWI-001/Additional_Study/analysis/fastqc_trimmed

mkdir -p ${OUTDIR}
mkdir -p ${OUTDIR1}
NCPU=2

#conda activate cutadapt
#remove polyA tails from reads
#for i in $DATA/SRR*.fastq.gz
#do
#         path="${i%.fastq*}";
#         sample_name=${path##*/};
#         cutadapt -a "A{7}" \
#                  -o ${OUTDIR}/${sample_name}_clipped.fastq.gz \
#                   ${DATA}/${sample_name}.fastq.gz
# done                  
#conda deactivate

#conda activate trimmomatic
#quality trimming of reads
#for i in $OUTDIR/SRR*_clipped.fastq.gz
#do
 #        path="${i%_clipped*}";
  #       sample_name=${path##*/};
  #        trimmomatic SE \
   #                  -threads $NCPU \
   #                  -phred33 \
   #                  ${OUTDIR}/${sample_name}_clipped.fastq.gz \
   #                  ${OUTDIR}/${sample_name}_clipped_trimmed.fastq.gz \
   #                  LEADING:15 \
   #                  TRAILING:15 \
   #                  MINLEN:35
#done
#conda deactivate

#wait

#remove adaptors
module load fastp
for i in $DATA/SRR*_clipped_trimmed.fastq.gz
do
         path="${i%_clipped_trimmed*}";
         sample_name=${path##*/};
         fastp -i ${OUTDIR}/${sample_name}_clipped_trimmed.fastq.gz \
               -o ${OUTDIR}/${sample_name}_rm_adaptor.fastq.gz \
               -h ${OUTDIR}/${sample_name}.fastp.html
done

wait

#run fastqc
module load fastqc
for fq in $OUTDIR/SRR*_rm_adaptor.fastq.gz
do
   fastqc -o ${OUTDIR1} --extract ${fq}
   
done 
