#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=trimmomatic
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=02:00:00
#SBATCH --mem=6G
#SBATCH --output=%j.out
set -eux

NCPU=2
source $HOME/.bashrc
conda activate trimmomatic

DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SCWI-001/Additional_Study/fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SCWI-001/Additional_Study/fastq_trimmed
#used parameter setting from paper sent by sccot https://www-sciencedirect-com.cyber.usask.ca/science/article/pii/S0092867419301138?via%3Dihub
mkdir -p ${OUTDIR}
for i in $DATA/SRR*.fastq.gz
do
         path="${i%.fastq*}";
         sample_name=${path##*/};
          trimmomatic SE \
                     -threads $NCPU \
                     -phred33 \
                     ${DATA}/${sample_name}.fastq.gz \
                     ${OUTDIR}/${sample_name}.fastq.gz \
                     ILLUMINACLIP:/globalhome/hxo752/HPC/anaconda3/envs/trimmomatic/share/trimmomatic/adapters/TruSeq3-SE.fa:2:30:10 \
                     LEADING:15 \
                     TRAILING:15 \
                     MINLEN:35
done
conda deactivate
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
