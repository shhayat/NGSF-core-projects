NCPU=4
RAM=40

gatk=$tools/gatk-4.1.8.1/gatk
picard=$tools/picard.jar
hisat2=$tools/hisat2-2.1.0/hisat2
samtools=$tools/samtools-1.10/samtools
bcftools=$tools/bcftools-1.10.2/bcftools
fasta_ref=$reference/GRCh38.d1.vd1.fa
gtf_ref=$reference/gencode.v36.annotation.gtf
hisat_ref=$reference/hisat2_GRCh38
igg_ref=$reference/IGG.gtf
hla_ref=$reference/HLA.gtf
pseudo_ref=$reference/pseudoGene.gtf
radar_ref=$reference/Radar_38.bed
darned_ref=$reference/Darned_38.bed
REDI_ref=$reference/RNA-EDI_38.bed
dbsnp_ref=$reference/common_all_20180418.vcf.gz
germline_ref=$reference/af-only-gnomad.hg38.vcf.gz 
PON_ref=$reference/1000g_pon.hg38.vcf.gz
genelist_ref=$reference/gg.list
tcga_PON_ref=$reference/MuTect2.PON.5210.vcf.gz

IMAPR=/globalhome/hxo752/HPC/tools/IMAPR
tools=/globalhome/hxo752/HPC/tools/IMAPR/tools
reference=/globalhome/hxo752/HPC/tools/IMAPR/reference
out_folder=/project/anderson/detect_variants

sample_name	sample1
input_format	RNA/RNA
tumor_input	/data1/gtang/git/data/tumor.bam
normal_input	/data1/gtang/git/data/normal.bam
out_prefix	/data1/gtang/git/data/out_put5

#system
thread	4
ram	40

#tools_reference
gatk	./tools/gatk-4.1.8.1/gatk
picard	./tools/picard.jar
samtools	./tools/samtools-1.10/samtools
bcftools	./tools/bcftools-1.10.2/bcftools
hisat2	./tools/hisat2-2.1.0/hisat2

#reference
fasta_ref  $reference/GRCh38.d1.vd1.fa
gtf_ref  $reference/gencode.v36.annotation.gtf
genelist_ref  $reference/gg.list
dbsnp_ref  $reference/common_all_20180418.vcf.gz
germline_ref  $reference/af-only-gnomad.hg38.vcf.gz 
PON_ref	./reference/1000g_pon.hg38.vcf.gz
hisat_ref	./reference/hisat2_GRCh38
igg_ref	./reference/IGG.gtf
hla_ref	./reference/HLA.gtf
pseudo_ref	./reference/pseudoGene.gtf
tcga_PON_ref  $reference/MuTect2.PON.5210.vcf.gz
radar_ref	./reference/Radar_38.bed
darned_ref	./reference/Darned_38.bed
REDI_ref	./reference/RNA-EDI_38.bed
