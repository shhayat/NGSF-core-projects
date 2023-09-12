#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=annovar
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=08:00:00
#SBATCH --mem=20G
#SBATCH  --output=%j_annovar.out

#detect low freq variants from general population and annotate variants
#https://peerj.com/articles/600/

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/SNPs_using_varscan2
annovar=/globalhome/hxo752/HPC/tools/annovar

#First convert VCF file to the format accepted by annovar
#${annovar}/convert2annovar.pl -format vcf4 ${DIR}/D23000043_snps_ReadDepth10_BaseQuality30.vcf  > ${DIR}/D23000043_snps.avinput
#${annovar}/convert2annovar.pl -format vcf4 ${DIR}/D23000044_snps_ReadDepth10_BaseQuality30.vcf  > ${DIR}/D23000044_snps.avinput

#Download databases for Determining the population frequency for SNPs
#${annovar}/annotate_variation.pl -buildver hg38 -downdb -webfrom annovar gnomad_exome ${annovar}/humandb/
#${annovar}/annotate_variation.pl -buildver hg38 -downdb -webfrom annovar exac03 ${annovar}/humandb/
#${annovar}/annotate_variation.pl -buildver hg38 -downdb -webfrom annovar avsnp147 ${annovar}/humandb/
#${annovar}/annotate_variation.pl -buildver hg38 -downdb -webfrom annovar 1000g2015aug ${annovar}/humandb/

#Determining the population frequency
${annovar}/table_annovar.pl ${DIR}/D23000043_snps.avinput humandb/ -buildver hg38 -out ${DIR}/D23000043_annotation -remove -protocol gnomad_exome,exac03,avsnp147,1000g2015aug -operation f,f,f,f,f -nastring . -csvout -polish
${annovar}/table_annovar.pl ${DIR}/D23000044_snps.avinput humandb/ -buildver hg38 -out ${DIR}/23000044_annotation -remove -protocol gnomad_exome,exac03,avsnp147,1000g2015aug -operation f,f,f,f,f -nastring . -csvout -polish
