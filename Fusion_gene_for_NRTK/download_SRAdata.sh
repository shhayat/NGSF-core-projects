#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=sra_download
#SBATCH --cpus-per-task=1
#SBATCH --mem=185G
#SBATCH --time=24:00:00
#SBATCH --output=%j.out

#Normal Skin Tissue
module load sra-toolkit/2.10.8
OUTPUT=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/Fusion_gene_for_NRTK/Normal_Skin
mkdir $OUTPUT
for i in SRR8474298 SRR8474287 SRR8474236 SRR8474246 SRR8474266
do
  prefetch $i -O $;
  fasterq-dump $i;
done

#Fibrosarcoma 
OUTPUT=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/Fusion_gene_for_NRTK/Fibrosarcoma
mkdir $OUTPUT
for i in SRR20327014 SRR20327015 SRR20327016 SRR20327011 SRR20327012 SRR20327013 SRR20327035 SRR20327036 SRR20327037 SRR20327006	
do
  prefetch $i;
  fasterq-dump $i;
done
