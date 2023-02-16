#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=sra_download
#SBATCH --cpus-per-task=1
#SBATCH --mem=185G
#SBATCH --time=20:00:00
#SBATCH --output=%j.out

sratoolkit=/globalhome/hxo752/HPC/tools/sratoolkit.3.0.1-ubuntu64/bin
NCPU=1
#Normal Skin Tissue
OUTPUT=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/Fusion_gene_for_NRTK/Normal_Skin
mkdir -p $OUTPUT
mkdir -p $OUTPUT/fastq
for i in SRR8474298 SRR8474287 SRR8474236 SRR8474246 SRR8474266
do
  echo "Generating sra file for: ${i}";
  ${sratoolkit}/prefetch $i -O $OUTPUT --progress;
  
  echo "Generating fastq for: ${i}";
  ${sratoolkit}/fastq-dump --outdir fastq --gzip --skip-technical --readids --read-filter pass --split-3 --clip ${OUTPUT}/${i}.sra;
  #${sratoolkit}/fasterq-dump --split-files $i -O $OUTPUT --threads $NCPU --progress;
  #${sratoolkit}/fasterq-dump --split-files $i -O $OUTPUT --threads $NCPU;
done

#Fibrosarcoma 
OUTPUT=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/Fusion_gene_for_NRTK/Fibrosarcoma
mkdir $OUTPUT
for i in SRR20327014 SRR20327015 SRR20327016 SRR20327011 SRR20327012 SRR20327013 SRR20327035 SRR20327036 SRR20327037 SRR20327006	
do
  echo "Generating sra file for: ${i}";
  ${sratoolkit}/prefetch $i -O $OUTPUT --progress;
  
  echo "Generating fastq for: ${i}";
  ${sratoolkit}/fastq-dump --outdir fastq --gzip --skip-technical --readids --read-filter pass --split-3 --clip ${OUTPUT}/${i}.sra;
done
