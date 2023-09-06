#select snps
gatk SelectVariants \
    -R reference.fasta \
    -V input.vcf \
    --select-type-to-include SNP \
    -O snps.vcf

#select rare variants
    gatk SelectVariants \
    -R reference.fasta \
    -V input.vcf \
    --select "AF <= 0.01" \
    -O rare_variants.vcf
