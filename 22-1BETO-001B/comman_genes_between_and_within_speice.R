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
 


#testing

d_cnt1$gene_name <- tolower(d_cnt1$gene_name)
d_cnt2$gene_name <- tolower(d_cnt2$gene_name)
h_cnt1$gene_name <- tolower(h_cnt1$gene_name)
h_cnt2$gene_name <- tolower(h_cnt2$gene_name)

#346 
df11 <- merge(d_cnt1,d_cnt2, by="GeneID")
#347
df1 <- merge(d_cnt1,d_cnt2, by="gene_name")
#> df1[df1$gene_name == "snord45",]
#    gene_name           GeneID.x baseMean.x log2FoldChange.x
#287   snord45 ENSCAFG00000020713   216.8799        0.5104533
#      lfcSE.x   stat.x   pvalue.x    padj.x Fold_Change.x
#287 0.2446688 2.086303 0.03695117 0.5655239      1.424498
#              GeneID.y baseMean.y log2FoldChange.y   lfcSE.y
#287 ENSCAFG00000021569   17.89392         1.689763 0.5851684
#      stat.y    pvalue.y    padj.y Fold_Change.y
#287 2.887652 0.003881293 0.0413301      3.226036

df22 <- merge(h_cnt1,h_cnt2, by="GeneID")
df2 <- merge(h_cnt1,h_cnt2, by="gene_name")
df2[!duplicated(df2$GeneID.x %in% df22$GeneID),] 

