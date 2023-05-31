#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=sra_download
#SBATCH --cpus-per-task=8
#SBATCH --mem=185G
#SBATCH --time=24:00:00
#SBATCH --output=%j.out

sratoolkit=/globalhome/hxo752/HPC/tools/sratoolkit.3.0.1-ubuntu64/bin
OUTPUT=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes

mkdir -p $OUTPUT/fastq

for i in {4369..4422}
do
  echo "Generating sra file for:  SRR1762${i}";
  ${sratoolkit}/prefetch SRR1762${i} -O $OUTPUT/fastq --progress;
  
  echo "Generating fastq for: SRR1762${i}";
  ${sratoolkit}/fastq-dump --outdir $OUTPUT/fastq --gzip --clip ${OUTPUT}/fastq/SRR1762${i}/SRR1762${i}.sra;
done
