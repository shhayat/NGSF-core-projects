library(dplyr)
library(pheatmap)
setwd("/Users/shahina/Projects/22-1KELA-001")


diff_genes<- read.csv("diff_genes.csv")
leukocyte_IFNa2 <- diff_genes[c(1,4,5,6)]
leukocyte_IFNa14 <- diff_genes[c(1,9,10,11)]

CD4_IFNa2 <- diff_genes[c(1,19,20,21)]
CD4_IFNa14 <- diff_genes[c(1,24,25,26)]

colnames(leukocyte_IFNa2) <- c("gene","log2FoldChange","pvalue","padj")
colnames(leukocyte_IFNa14) <- c("gene","log2FoldChange","pvalue","padj")

colnames(CD4_IFNa2) <- c("gene","log2FoldChange","pvalue","padj")
colnames(CD4_IFNa14) <- c("gene","log2FoldChange","pvalue","padj")


#filter on 0.05 fdr
#filter on 0.01 fdr
leukocyte_IFNa2_f <- filter(leukocyte_IFNa2, padj <= 0.01)
leukocyte_IFNa14_f <- filter(leukocyte_IFNa14, padj <= 0.01)
CD4_IFNa2_f <- filter(CD4_IFNa2, padj <= 0.01)
CD4_IFNa14_f <- filter(CD4_IFNa14, padj <= 0.01)

leukocyte_IFNa2_IFNa14 <- merge(leukocyte_IFNa2_f,leukocyte_IFNa14_f, by="gene") #all=TRUE
CD4_IFNa2_IFNa14 <- merge(CD4_IFNa2_f,CD4_IFNa14_f, by="gene") #all=TRUE

leukocyte_IFNa2_IFNa14 <- leukocyte_IFNa2_IFNa14[c(1,2,5)]
CD4_IFNa2_IFNa14 <- CD4_IFNa2_IFNa14[c(1,2,5)]
colnames(leukocyte_IFNa2_IFNa14) <- c("gene","leukocyte_IFNa2", "leukocyte_IFNa14")
colnames(CD4_IFNa2_IFNa14) <- c("gene","CD4_IFNa2", "CD4_IFNa14")
#rownames(leukocyte_IFNa2_IFNa14) <- leukocyte_IFNa2_IFNa14$gene
#rownames(CD4_IFNa2_IFNa14) <- CD4_IFNa2_IFNa14$gene
#leukocyte_IFNa2_IFNa14 <- leukocyte_IFNa2_IFNa14[-1]
#CD4_IFNa2_IFNa14 <- CD4_IFNa2_IFNa14[-1]

#leukocyte_IFNa2_IFNa14[is.na(leukocyte_IFNa2_IFNa14)] <- 0
#CD4_IFNa2_IFNa14[is.na(CD4_IFNa2_IFNa14)] <- 0

write.table(leukocyte_IFNa2_IFNa14, "/Users/shahina/Desktop/leukocyte_IFNa2_IFNa14.txt", sep="\t", quote=FALSE, row.names = FALSE)
write.table(CD4_IFNa2_IFNa14, "/Users/shahina/Desktop/CD4_IFNa2_IFNa14.txt", sep="\t", quote=FALSE, row.names = FALSE)

#MEV was used to create Heatmaps

#################
#VENN DIAGRAM
#################
library(eulerr)

setwd("/Users/shahina/Projects/22-1KELA-001")

diff_genes<- read.csv("diff_genes.csv")
leukocyte_IFNa2 <- diff_genes[c(1,4,5,6)]
leukocyte_IFNa14 <- diff_genes[c(1,9,10,11)]

CD4_IFNa2 <- diff_genes[c(1,19,20,21)]
CD4_IFNa14 <- diff_genes[c(1,24,25,26)]

colnames(leukocyte_IFNa2) <- c("gene","log2FoldChange","pvalue","padj")
colnames(leukocyte_IFNa14) <- c("gene","log2FoldChange","pvalue","padj")

colnames(CD4_IFNa2) <- c("gene","log2FoldChange","pvalue","padj")
colnames(CD4_IFNa14) <- c("gene","log2FoldChange","pvalue","padj")

leukocyte_IFNa2 <- leukocyte_IFNa2[-1,]
leukocyte_IFNa14 <- leukocyte_IFNa14[-1,]
CD4_IFNa2 <- CD4_IFNa2[-1,]
CD4_IFNa14 <- CD4_IFNa14[-1,]
#filter on 0.05 pvalue
leukocyte_IFNa2_f <- filter(leukocyte_IFNa2, padj <= 0.05)
leukocyte_IFNa14_f <- filter(leukocyte_IFNa14, padj <= 0.05)
CD4_IFNa2_f <- filter(CD4_IFNa2, padj <= 0.05)
CD4_IFNa14_f <- filter(CD4_IFNa14, padj <= 0.05)


png("plots/VennDiagram_leukocyte_fdr0.05.png", width=550)
leukocyte <- list(IFNa2 = leukocyte_IFNa2_f$gene,
                  IFNa14 = leukocyte_IFNa14_f$gene)

plot(euler(leukocyte, shape = "ellipse"), quantities = TRUE, fill=yarrr::transparent(c('palegreen1','salmon2'), .3), title="Leukocyte")
dev.off()

png("plots/VennDiagram_CD4_fdr0.05.png" , width=550)
CD4 <- list(IFNa2 = CD4_IFNa2_f$gene,
            IFNa14 = CD4_IFNa14_f$gene)

plot(euler(CD4, shape = "circle"), quantities = TRUE, fill=yarrr::transparent(c('palegreen1','salmon2'), .3))

dev.off()
