#setwd("/Users/shahina/Projects/23-1MICO-001/")
setwd("/Users/hxo752/Desktop/23-1MICO-001/")
library(data.table)
shared_snp <- fread("shared_snp_annotation.hg38_multianno.csv")
shared_snp <- shared_snp[,c(1:9,139,11:15, 19:21, 31:33, 67:69, 106,122,131,140)]
shared_snp_AF0.01 <- shared_snp[shared_snp$gnomad312_AF <= 0.01 & shared_snp$gnomAD_exome_ALL <= 0.01 & shared_snp$ExAC_ALL <= 0.01 & shared_snp$`1000g2015aug_all` <= 0.01]
shared_snp_df <- shared_snp_AF0.01[!((shared_snp_AF0.01$gnomad312_AF == ".") & (shared_snp_AF0.01$gnomAD_exome_ALL == ".") & (shared_snp_AF0.01$ExAC_ALL==".") & (shared_snp_AF0.01$`1000g2015aug_all`==".")),]

#unique genes 563
length(unique(shared_snp_df$Gene.ensGene41))
write.csv(shared_snp_df,"shared_snps_with_AF_less_than0.01_across_databases.csv")


unique_snp <- fread("D23000043_snp_annotation.hg38_multianno.csv")
unique_snp <- unique_snp[,c(1:9,139,11:15, 19:21, 31:33, 67:69, 106,122,131,140)]
unique_snp_AF0.01 <- unique_snp[unique_snp$gnomad312_AF <= 0.01 & unique_snp$gnomAD_exome_ALL <= 0.01 & unique_snp$ExAC_ALL <= 0.01 & unique_snp$`1000g2015aug_all` <= 0.01]

unique_snp_df <- unique_snp_AF0.01[!((unique_snp_AF0.01$gnomad312_AF == ".") & (unique_snp_AF0.01$gnomAD_exome_ALL == ".") & (unique_snp_AF0.01$ExAC_ALL==".") & (unique_snp_AF0.01$`1000g2015aug_all`==".")),]

#unique genes 552
length(unique(unique_snp_df$Gene.ensGene41))
write.csv(unique_snp_df,"unique_snps_with_AF_less_than0.01_across_databases.csv")
