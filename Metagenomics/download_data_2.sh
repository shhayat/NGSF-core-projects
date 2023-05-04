#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=sra_download
#SBATCH --cpus-per-task=1
#SBATCH --mem=185G
#SBATCH --time=20:00:00
#SBATCH --output=%j.out

sratoolkit=/globalhome/hxo752/HPC/tools/sratoolkit.3.0.1-ubuntu64/bin
OUTPUT=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/Metagenomics

mkdir -p $OUTPUT
mkdir -p $OUTPUT/fastq/inulin_fl

for i in SRR17156289 SRR17156290
do
  echo "Generating sra file for: ${i}";
  ${sratoolkit}/prefetch $i -O $OUTPUT/fastq/inulin_fl --progress;
  
  echo "Generating fastq for: ${i}";
  ${sratoolkit}/fastq-dump --outdir $OUTPUT/fastq/inulin_fl --gzip --clip $OUTPUT/fastq/inulin_fl/${i}/${i}.sra;
done
