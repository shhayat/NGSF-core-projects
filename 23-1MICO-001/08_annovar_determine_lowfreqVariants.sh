#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=annovar
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=08:00:00
#SBATCH --mem=10G
#SBATCH  --output=%j_annovar.out

#detect low freq variants from general population and annotate variants
#https://peerj.com/articles/600/

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/SNPs_using_varscan2
annovar=/globalhome/hxo752/HPC/tools/annovar
vt=/globalhome/hxo752/HPC/tools/vt
GENOME=/datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/annovar

mkdir -p ${OUTDIR}
#First convert VCF file to the format accepted by annovar
${annovar}/convert2annovar.pl -format vcf4 ${DIR}/unique_to_D23000043.vcf > ${OUTDIR}/D23000043_unique_snps.avinput
${annovar}/convert2annovar.pl -format vcf4 ${DIR}/shared_snps.vcf > ${OUTDIR}/shared_snps.avinput

#Download databases for Determining the population frequency for SNPs
#${annovar}/annotate_variation.pl -buildver hg38 -downdb -webfrom annovar gnomad_exome ${annovar}/humandb/
#${annovar}/annotate_variation.pl -buildver hg38 -downdb -webfrom annovar exac03 ${annovar}/humandb/
#${annovar}/annotate_variation.pl -buildver hg38 -downdb -webfrom annovar avsnp150 ${annovar}/humandb/
#${annovar}/annotate_variation.pl -buildver hg38 -downdb -webfrom annovar 1000g2015aug ${annovar}/humandb/
#{annovar}/annotate_variation.pl -buildver hg38 -downdb -webfrom annovar ensGene41 ${annovar}/humandb/
#{annovar}/annotate_variation.pl -buildver hg38 -downdb -webfrom annovar gnomad312_genome ${annovar}/humandb/

#latest clinvar file was downloaded from https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38/clinvar_20230917.vcf.gz and converted it to format required by annovar using https://github.com/mobidic/update_annovar_db
#python /globalhome/hxo752/HPC/tools/update_annovar_db/update_resources.py -d clinvar -hp /globalhome/hxo752/HPC/tools/annovar/humandb/ -a /globalhome/hxo752/HPC/tools/annovar -g GRCh38
#${vt}/vt decompose /globalhome/hxo752/HPC/tools/annovar/humandb/clinvar_20230917.vcf.gz -o ${annovar}/humandb/temp.split.vcf
#${annovar}/prepare_annovar_user.pl -dbtype clinvar_preprocess2 ${annovar}/humandb/temp.split.vcf -out ${annovar}/humandb/temp.split2.vcf
${annovar}/convert2annovar.pl -dbtype clinvar_preprocess2 ${annovar}/humandb/temp.split.vcf ${annovar}/humandb/
#${vt}/vt normalize ${annovar}/humandb/temp.split2.vcf -r ${GENOME} -o ${annovar}/humandb/temp.norm.vcf -w 2000000
#${annovar}/prepare_annovar_user.pl -dbtype clinvar2 ${annovar}/humandb/temp.norm.vcf -out ${annovar}/humandb/hg38_clinvar_20230917_raw.txt
#${annovar}/index_annovar.pl ${annovar}/humandb/hg38_clinvar_20230917_raw.txt -out ${annovar}/humandb/hg38_clinvar_20230917.txt -comment ${annovar}/humandb/comment_20230917.txt
          
#Determining the population frequency
${annovar}/table_annovar.pl ${OUTDIR}/D23000043_unique_snps.avinput /globalhome/hxo752/HPC/tools/annovar/humandb/ -buildver hg38 -out ${OUTDIR}/D23000043_snp_annotation -remove -protocol ensGene41,gnomad312_genome,gnomad_exome,exac03,avsnp150,1000g2015aug_all -operation g,f,f,f,f,f -nastring . -csvout -polish
${annovar}/table_annovar.pl ${OUTDIR}/shared_snps.avinput /globalhome/hxo752/HPC/tools/annovar/humandb/ -buildver hg38 -out ${OUTDIR}/shared_snp_annotation -remove -protocol ensGene41,gnomad312_genome,gnomad_exome,exac03,avsnp150,1000g2015aug_all -operation g,f,f,f,f,f -nastring . -csvout -polish

#${annovar}/annotate_variation.pl -filter -dbtype 1000g2015aug -buildver hg38 -out ${DIR}/D23000043_annotation_1000g ${DIR}/D23000043_snps.avinput /globalhome/hxo752/HPC/tools/annovar/humandb/ -maf 0.05 -reverse
#${annovar}/annotate_variation.pl -filter -dbtype 1000g2015aug -buildver hg38 -out ${DIR}/D23000044_annotation_1000g ${DIR}/D23000044_snps.avinput /globalhome/hxo752/HPC/tools/annovar/humandb/ -maf 0.05 -reverse
