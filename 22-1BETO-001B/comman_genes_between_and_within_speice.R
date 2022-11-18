#Commen genes within specie

within <- function(contrast1, contrast2, specie) {
 
contrast1$gene_name <- tolower(contrast1$gene_name)
contrast2$gene_name <- tolower(contrast2$gene_name)

df <- merge(contrast1,contrast2, by="gene_name")
return(nrow(df))
write.csv(df,file=sprintf("DEG_common_genes_%s.csv",specie),quote=FALSE, row.names = FALSE)

}

setwd("/Users/shahina/Projects/22-1BETO-001/DESEQ2/")
d_cnt1 <- read.csv("DEG_AB4_vs_ABN_filter_on_pval.csv")
d_cnt2 <- read.csv("DEG_D4_vs_DN_filter_on_pval.csv")
within(d_cnt1,d_cnt2,"canis")

setwd("/Users/shahina/Projects/22-1BETO-001B/DESEQ2/")
h_cnt1 <- read.csv("DEG_144_vs_14N_filter_on_pval.csv")
h_cnt2 <- read.csv("DEG_MG4_vs_MGN_filter_on_pval.csv")
within(h_cnt1,h_cnt2,"human")


