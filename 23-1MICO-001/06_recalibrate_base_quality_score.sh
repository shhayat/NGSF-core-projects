
gatk BaseRecalibrator \
   -I my_reads.bam \
   -R reference.fasta \
   --known-sites sites_of_variation.vcf \
   --known-sites another/optional/setOfSitesToMask.vcf \
   -O recal_data.table

  gatk ApplyVQSR \
   -R Homo_sapiens_assembly38.fasta \
   -V input.vcf.gz \
   -O output.vcf.gz \
   --truth-sensitivity-filter-level 99.0 \
   --tranches-file output.tranches \
   --recal-file output.recal \
   -mode SNP
