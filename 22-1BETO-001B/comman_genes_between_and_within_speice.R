#Commen genes within specie

within <- function(contrast1, contrast2, specie, cont1, cont2) {
 
#contrast1$gene_name <- tolower(contrast1$gene_name)
#contrast2$gene_name <- tolower(contrast2$gene_name)

df <- merge(contrast1,contrast2, by="GeneID",suffixes=c(sprintf(".%s",cont1),sprintf(".%s",cont2)))
#return(nrow(df))
write.csv(df,file=sprintf("DEG_common_genes_%s.csv",specie),quote=FALSE, row.names = FALSE)

}

setwd("/Users/shahina/Projects/22-1BETO-001/DESEQ2/")
d_cnt1 <- read.csv("DEG_AB4_vs_ABN_filter_on_pval.csv")
d_cnt2 <- read.csv("DEG_D4_vs_DN_filter_on_pval.csv")
within(d_cnt1,d_cnt2,"canis","AB4_ABN", "D4_DN")

setwd("/Users/shahina/Projects/22-1BETO-001B/DESEQ2/")
h_cnt1 <- read.csv("DEG_144_vs_14N_filter_on_pval.csv")
h_cnt2 <- read.csv("DEG_MG4_vs_MGN_filter_on_pval.csv")
within(h_cnt1,h_cnt2,"human", "144_14N","MG4_MGN")



#between species

d_cnt1$gene_name <- tolower(d_cnt1$gene_name)
d_cnt2$gene_name <- tolower(d_cnt2$gene_name)
h_cnt1$gene_name <- tolower(h_cnt1$gene_name)
h_cnt2$gene_name <- tolower(h_cnt2$gene_name)
 
df1 <- merge(d_cnt1,d_cnt2, by="gene_name", suffix=c(".AB4_vs_ABN",".D4_vs_DN"))

df2 <- merge(df1,h_cnt1, by="gene_name",suffix=c(".x",".144_vs_14N"))

df3 <- merge(df2,h_cnt2, by="gene_name",suffix=c(".144_vs_14N",".MG4_vs_MGN"))

nrow(df3)
write.csv(df3,file="DEG_common_genes_between_species.csv",quote=FALSE, row.names = FALSE)
 
