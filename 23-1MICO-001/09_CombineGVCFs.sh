
 
 gatk CombineGVCFs \
   -R reference.fasta \
   --variant sample1.g.vcf.gz \
   --variant sample2.g.vcf.gz \
   -O cohort.g.vcf.gz
