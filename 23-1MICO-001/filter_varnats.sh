module load bcftools/1.13

bcftools view -i 'INFO/AF < 0.01' input.vcf > output_filtered.vcf
