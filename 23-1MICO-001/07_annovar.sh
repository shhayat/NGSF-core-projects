#detect low freq variants from general population and annotate variants
#https://peerj.com/articles/600/

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/SNPs_using_varscan2

#First convert VCF file to the format accepted by annovar
convert2annovar.pl -format vcf4 ${DIR}/D23000043_snps_ReadDepth10_BaseQuality30.vcf  > ${DIR}/D23000043_snps.avinput
convert2annovar.pl -format vcf4 ${DIR}/D23000044_snps_ReadDepth10_BaseQuality30.vcf  > ${DIR}/D23000044_snps.avinput
