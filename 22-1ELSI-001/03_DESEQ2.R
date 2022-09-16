library("DESeq2")
library("ggplot2")
library("dplyr")
library("ggrepel")

setwd("~/Desktop/")
dir.create("core-projects/22-1ELSI-001/DESEQ2", recursive=TRUE, showWarnings = FALSE) 

load("core-projects/22-1ELSI-001/feature_count.RData")
feature_count1 <- as.data.frame(feature_count)
#geneID <- gsub(".[0-9]*$", "", rownames(feature_count))
#rownames(feature_count) <- geneID

#your first columns which are gene id and gene name
feature_annotation <- feature_count1[1:2]
#feature_annotation$GeneID <- gsub(".[0-9]*$", "",feature_annotation$GeneID)


#feature_count <- feature_count[colnum]
#
#this will only store your samples with their expression values AND samples are arranged according to groups
feature_count <- feature_count1[c(6,10,8,7,3,13,12,11,5,17,14,9,15,16,4)]
#at least one column has number
#feature_count3 <- feature_count2[apply(feature_count2,1,function(z) any(z!=0)),]
#feature_count3 <- feature_count2[apply(feature_count2, 1,function(x) all(x[1:5] >=1) && all(x[6:10]==0) && all(x[11:15]==0)),]

f1 <- feature_count %>% 
  filter(if_all(c(1:5), ~ . >=1) & if_all(c(6:10), ~ . ==0) & if_all(c(11:15), ~ . ==0))

f2 <- feature_count %>% 
  filter(if_all(c(1:5), ~ . ==0) & if_all(c(6:10), ~ . >=1) & if_all(c(11:15), ~ . >=1))

f3 <- feature_count %>% 
  filter(if_all(c(1:5), ~ . >=1) & if_all(c(6:10), ~ . >=1) & if_all(c(11:15), ~ . ==0))

f4 <- feature_count %>% 
  filter(if_all(c(1:5), ~ . ==0) & if_all(c(6:10), ~ . ==0) & if_all(c(11:15), ~ . >=1))

f5 <- feature_count %>% 
  filter(if_all(c(1:5), ~ . >=1) & if_all(c(6:10), ~ . ==0) & if_all(c(11:15), ~ . >=1))

f6 <- feature_count %>% 
  filter(if_all(c(1:5), ~ . >=1) & if_all(c(6:10), ~ . >=1) & if_all(c(11:15), ~ . >=1))

feature_count3 <- rbind(f1,f2,f3,f4,f5,f6)         
#creating SAMPLE INFORMATION VARIABLE with group definition
sampleInfo=data.frame(sample_name=dput(as.character(names(feature_count3))),
                      sample_type=dput(as.character(names(feature_count3))),
                      sample_group=dput(as.character(c(rep("D1",5),rep("D4",5), rep("LPS",5)))))



group <- data.frame(sample_group=sampleInfo$sample_group)

dds <- DESeqDataSetFromMatrix(countData=feature_count3,
                              colData=group,
                              design=~sample_group)

##########
#PCA PLOT
##########
#gernate rlog for PCA

pdf("core-projects/22-1ELSI-001/DESEQ2/PCA_for_3_groups.pdf")

#rld <-rlog(dds,blind=FALSE)
#pdf(sprintf("PCA_%s_%s.pdf",cond2,cond1), width=15,height=15)
nudge <- position_nudge(y = 0.5)
p <- plotPCA(rld,intgroup=c("sample_group"))  
p <- p + geom_text(aes_string(label = "name"), color="black", position = nudge, size=2.4)
p

dev.off()


dds_wald <- DESeq(dds, betaPrior=FALSE, minReplicatesForReplace=Inf)

#########
#BOX PLOT
#########
boxplot(log10(assays(dds_wald)[["cooks"]]), range=0, las=2)


#Differential Expression Analysis for 2 groups with pvalue less than 0.05
#resLFC_shrunken_D1_D4 <- lfcShrink(dds_wald, contrast=c("sample_group","D4","D1"), type="normal")
#resLFC_shrunken_D1_LPS <- lfcShrink(dds_wald, contrast=c("sample_group","LPS","D1"),  type="normal")

resLFC_shrunken_D1_D4 <- lfcShrink(dds_wald, coef=2, type="apeglm")
resLFC_shrunken_D1_LPS <- lfcShrink(dds_wald, coef=3,  type="apeglm")

#Differential Expression Analysis for 2 groups with pvalue less than 0.05
#res_D1_D4 <- results(dds_wald  , contrast=c("sample_group","D1","D4"), alpha=0.05)
#res_D1_LPS <- results(dds_wald, contrast=c("sample_group","D1","LPS"), alpha=0.05)


#Summary of results
summary(resLFC_shrunken_D1_D4, alpha=0.01)
summary(resLFC_shrunken_D1_LPS, alpha=0.01)

#MA plot to see most significant genes
pdf("MAplot.pdf")
plotMA(resLFC_shrunken_D1_D4, ylim=c(-4,4))
plotMA(resLFC_shrunken_D1_LPS, ylim=c(-4,4))
dev.off()

#Plot counts for particular gene or the gene with lowest fdr
#plotCounts(dds_wald, gene="ENSECAG00000012421", intgroup="sample_group")
#plotCounts(dds_wald, gene=which.min(res_D1_D4$padj), intgroup="sample_group")

#summary(res)

#D1 and D4
#All significant at pvalue 0.05
resDF <- data.frame(GeneID=rownames(resLFC_shrunken_D1_D4),resLFC_shrunken_D1_D4)
resDF <- merge(feature_annotation,resDF, by="GeneID")

resDF1 <- resDF[resDF$pvalue <= 0.05,]
res_pval_ordered <- resDF1[order(resDF1$pvalue),]
res_pval_ordered <- res_pval_ordered[rowSums(is.na(res_pval_ordered)) == 0, ] 

write.csv(res_pval_ordered,file="core-projects/22-1ELSI-001/DESEQ2/DESEQ2_res_D1_D4_at_pvalue_0.05.csv",quote=FALSE, row.names = FALSE)

#All significant at FDR 0.01
resDF2 <- resDF[resDF$padj <= 0.01,]
res_padj_ordered <- resDF2[order(resDF2$padj),]
res_padj_ordered <- res_padj_ordered[rowSums(is.na(res_padj_ordered)) == 0, ] 

write.csv(res_padj_ordered,file="core-projects/22-1ELSI-001/DESEQ2/DESEQ2_res_D1_D4_at_fdr_0.01.csv",quote=FALSE, row.names = FALSE)


#volcano plot
#remove rows if padj is NA
d1d4_df <- res_padj_ordered[!is.na(res_padj_ordered$padj), ]
#assign up and down regulation and non signif based on log2fc
d1d4_df$direction <- ifelse(as.numeric(d1d4_df$log2FoldChange) < -4, "down_regulated", 
                                   ifelse(as.numeric(d1d4_df$log2FoldChange) > 4, "up_regulated", "signif" ))
  
pdf("D1_D4_Volcano_plot_padj0.01_and_log2FC_4.pdf")
  p <- ggplot(d1d4_df, aes(as.numeric(log2FoldChange), -log10(as.numeric(padj)))) +
    geom_point(aes(col=direction),size=0.4,show.legend = FALSE) +
    scale_color_manual(values=c("blue", "gray", "red")) +
    theme(axis.text.x = element_text(size=11),
          axis.text.y = element_text(size=11),
          text = element_text(size=11)) +
    xlab("log2(FC)") +
    ylab("-log10(FDR)") 

  #order up and down on lowest adj pvalue
  up <- d1d4_df[d1d4_df$direction == "up_regulated",]
  up_ordered <- up[order(up$padj),]
  down <- d1d4_df[d1d4_df$direction == "down_regulated",]
  down_ordered <- down[order(down$padj),]
  
  p1 <- p + geom_text_repel(data=head(up_ordered,10),aes(label=gene_name),size=2, box.padding = unit(0.7, "lines"), max.overlaps = Inf)
  p2 <- p1 + geom_text_repel(data=head(down_ordered,10),aes(label=gene_name),size=2, box.padding = unit(0.7, "lines"), max.overlaps = Inf)
  print(p2)
dev.off()
  


#D1 and LPS
#All significant at pvalue 0.05
resDF <- data.frame(GeneID=rownames(resLFC_shrunken_D1_LPS),resLFC_shrunken_D1_LPS)
resDF <- merge(feature_annotation,resDF, by="GeneID")

resDF1 <- resDF[resDF$pvalue <= 0.05,]
res_pval_ordered <- resDF1[order(resDF1$pvalue),]
res_pval_ordered <- res_pval_ordered[rowSums(is.na(res_pval_ordered)) == 0, ] 

write.csv(res_pval_ordered,file="core-projects/22-1ELSI-001/DESEQ2/DESEQ2_res_D1_LPS_at_pvalue_0.05.csv",quote=FALSE, row.names = FALSE)

#All significant at FDR 0.01
resDF2 <- resDF[resDF$padj <= 0.01,]
res_padj_ordered <- resDF2[order(resDF2$padj),]
res_padj_ordered <- res_padj_ordered[rowSums(is.na(res_padj_ordered)) == 0, ] 

write.csv(res_padj_ordered,file="core-projects/22-1ELSI-001/DESEQ2/DESEQ2_res_D1_LPS_at_fdr_0.01.csv",quote=FALSE, row.names = FALSE)


#comman genes between two contrasts
comman_genes_at_fdr0.01 <- merge(res_padj_ordered1,res_padj_ordered2, by="GeneID", suffix=c(".D4_vs_D1",".LPS_vs_D1"))
write.csv(comman_genes_at_fdr0.01,file="DESEQ2/comman_genes_at_fdr_0.01.csv",quote=FALSE, row.names = FALSE)


#volcano plot
#remove rows if padj is NA
d1lps_df <- res_padj_ordered[!is.na(res_padj_ordered$padj), ]
#assign up and down regulation and non signif based on log2fc
d1lps_df$direction <- ifelse(as.numeric(d1lps_df$log2FoldChange) < -4, "down_regulated", 
                                 ifelse(as.numeric(d1lps_df$log2FoldChange) > 4, "up_regulated", "signif" ))

pdf("D1_LPS_Volcano_plot_padj0.01_and_log2FC_4.pdf")
p <- ggplot(d1lps_df, aes(as.numeric(log2FoldChange), -log10(as.numeric(padj)))) +
  geom_point(aes(col=direction),size=0.4,show.legend = FALSE) +
  scale_color_manual(values=c("blue", "gray", "red")) +
  theme(axis.text.x = element_text(size=11),
        axis.text.y = element_text(size=11),
        text = element_text(size=11)) +
  xlab("log2(FC)") +
  ylab("-log10(FDR)") 

#order up and down on lowest adj pvalue
up <- d1lps_df[d1lps_df$direction == "up_regulated",]
up_ordered <- up[order(up$padj),]
down <- d1lps_df[d1lps_df$direction == "down_regulated",]
down_ordered <- down[order(down$padj),]

p1 <- p + geom_text_repel(data=head(up_ordered,10),aes(label=gene_name),size=2, box.padding = unit(0.7, "lines"), max.overlaps = Inf)
p2 <- p1 + geom_text_repel(data=head(down_ordered,10),aes(label=gene_name),size=2, box.padding = unit(0.7, "lines"), max.overlaps = Inf)
print(p2)
dev.off()


library(eulerr)
#Venn Diagram 

pdf("DESEQ2/VennDiagram_at_fdr0.01.pdf", width=10, height=3)
  D1_D4 <- res_pval_ordered1
  D1_LPS <- res_padj_ordered2

  s1 <- list(D4_vs_D1 = D1_D4$GeneID,
             LPS_vs_D1 = D1_LPS$GeneID)
  ##Total genes common between two contrast
  plot(euler(s1, shape = "circle"), quantities = TRUE, fill=yarrr::transparent(c('palegreen1','salmon2'), .1),main="All genes (up and down regulated)")

  #Up regulated Genes common between two contrast
  D1_D4_up <- D1_D4[D1_D4$log2FoldChange >= 0,]$GeneID 
  D1_LPS_up <- D1_LPS[D1_LPS$log2FoldChange >= 0,]$GeneID 

  s2 <- list(D4_vs_D1 = D1_D4_up,
             LPS_vs_D1 = D1_LPS_up)

  plot(euler(s2, shape = "circle"), quantities = TRUE, fill=yarrr::transparent(c('palegreen1','salmon2'), .1) ,main="Up regulated")

  #Down regulated genes common between two contrast
  D1_D4_down <- D1_D4[D1_D4$log2FoldChange <= 0,]$GeneID 
  D1_LPS_down <- D1_LPS[D1_LPS$log2FoldChange <= 0,]$GeneID 

  s3 <- list(D4_vs_D1 = D1_D4_down,
             LPS_vs_D1 = D1_LPS_down)

  plot(euler(s3, shape = "circle"), quantities = TRUE, fill=yarrr::transparent(c('palegreen1','salmon2'), .1),main="Down regulated")

dev.off()


#Count plot
library(ggtree)
#plot count top 10 differntially expressed genes for D4 vs D1
pdf("DESEQ2/count_plot_D1_D4.pdf", height=20, width=15)
#select top 10 genes on lowest fdr
gene_ids = head(res_padj_ordered1$GeneID, 10)
myplots <- list()  # new empty list
for (gene in gene_ids)
{
  d <- plotCounts(dds_wald, gene= gene, 
                  intgroup="sample_group", returnData=TRUE)

  p <- ggplot(d, aes(x=sample_group, y=count)) + 
    geom_point(position=position_jitter(w=0.1,h=0)) +
    ylab("Normalized Count") +
    ggtitle(paste(gene,":",res_padj_ordered1[res_padj_ordered1$GeneID==gene,]$gene_name,": FDR ",res_padj_ordered1[res_padj_ordered1$GeneID==gene,]$padj))
  
  myplots[[gene]] <- p 
  
}
multiplot(plotlist = myplots, ncol = 2)

dev.off()



pdf("DESEQ2/count_plot_D1_LPS.pdf", height=20, width=15)
gene_ids = head(res_padj_ordered2$GeneID, 10)
myplots <- list()  # new empty list
for (gene in gene_ids)
{
  d <- plotCounts(dds_wald, gene= gene, 
                  intgroup="sample_group", returnData=TRUE)
  
  p <- ggplot(d, aes(x=sample_group, y=count)) + 
    geom_point(position=position_jitter(w=0.1,h=0)) + 
    ylab("Normalized Count") +
    #scale_y_log10(breaks=c(100,1000,3000,6000)) +
    ggtitle(paste(gene,":",res_padj_ordered2[res_padj_ordered2$GeneID==gene,]$gene_name,": FDR ",res_padj_ordered2[res_padj_ordered2$GeneID==gene,]$padj))
  
  myplots[[gene]] <- p 
  
}
multiplot(plotlist = myplots, ncol = 2)

dev.off()


#plotCounts(dds_wald, gene="KBTBD7", intgroup="sample_group")

