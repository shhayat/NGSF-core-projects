Recalibration Base quality score step should be run before calling mutect2. This was part of pre processing step which was missed in this project

#https://console.cloud.google.com/storage/browser/gcp-public-data--broad-references/hg38/v0?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22))&prefix=&forceOnObjectsSortingFiltering=false
java -jar GenomeAnalysisTK.jar \ 
    -T BaseRecalibrator \ 
    -R reference.fa \ 
    -I input_reads.bam \ 
    -L 20 \ 
    -knownSites dbsnp.vcf \ 
    -knownSites gold_indels.vcf \ 
    -o recal_data.table 
    
    java -jar GenomeAnalysisTK.jar \ 
    -T BaseRecalibrator \ 
    -R reference.fa \ 
    -I realigned_reads.bam \ 
    -L 20 \ 
    -knownSites dbsnp.vcf \ 
    -knownSites gold_indels.vcf \ 
    -BQSR recal_data.table \ 
    -o post_recal_data.table 



check this https://learn.gencore.bio.nyu.edu/variant-calling/pre-processing/
