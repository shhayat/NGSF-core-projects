module load bcftools/1.13


bcftools view -i 'INFO/AF < 0.01' D23000043_snps_ReadDepth10_BaseQuality30.vcf > D23000043_snps_AF0.01.vcf
bcftools view -i 'INFO/AF < 0.01' D23000044_snps_ReadDepth10_BaseQuality30.vcf > D23000044_snps_AF0.01.vcf
