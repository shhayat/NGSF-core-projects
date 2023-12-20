library("DESeq2")
library("ggplot2")
library("dplyr")
library("ggrepel")

#setwd("~/Desktop/")
#dir.create("core-projects/22-1ELSI-001/DESEQ2", recursive=TRUE, showWarnings = FALSE) 
#setwd("~/Desktop/core-projects/22-1ELSI-001")
setwd("/Users/shahina/Projects/22-1ELSI-001/")

load("feature_count.RData")
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

#f1 <- feature_count %>% 
#  filter(if_all(c(1:5), ~ . >=1) & if_all(c(6:10), ~ . ==0) & if_all(c(11:15), ~ . ==0))

#f2 <- feature_count %>% 
#  filter(if_all(c(1:5), ~ . ==0) & if_all(c(6:10), ~ . >=1) & if_all(c(11:15), ~ . >=1))

#f3 <- feature_count %>% 
#  filter(if_all(c(1:5), ~ . >=1) & if_all(c(6:10), ~ . >=1) & if_all(c(11:15), ~ . ==0))

#f4 <- feature_count %>% 
#  filter(if_all(c(1:5), ~ . ==0) & if_all(c(6:10), ~ . ==0) & if_all(c(11:15), ~ . >=1))

#f5 <- feature_count %>% 
#  filter(if_all(c(1:5), ~ . >=1) & if_all(c(6:10), ~ . ==0) & if_all(c(11:15), ~ . >=1))

#f6 <- feature_count %>% 
#  filter(if_all(c(1:5), ~ . >=1) & if_all(c(6:10), ~ . >=1) & if_all(c(11:15), ~ . >=1))

#feature_count3 <- rbind(f1,f2,f3,f4,f5,f6)         
#creating SAMPLE INFORMATION VARIABLE with group definition
sampleInfo=data.frame(sample_name=dput(as.character(names(feature_count))),
                      sample_type=dput(as.character(names(feature_count))),
                      sample_group=dput(as.character(c(rep("D1",5),rep("D4",5), rep("LPS",5)))))



group <- data.frame(sample_group=sampleInfo$sample_group)

dds <- DESeqDataSetFromMatrix(countData=feature_count,
                              colData=group,
                              design=~sample_group)


#get normalized counts
dds <- estimateSizeFactors(dds)
norm.expr <- counts(dds, normalized=TRUE)
norm.expr <- as.data.frame(norm.expr)
norm.expr <- data.frame(rownames(norm.expr),norm.expr)
colnames(norm.expr) <- c("GeneID","E1L1","E2L1","E3L1","E4L1","E5L1","E1L4","E2L4","E3L4","E4L4","E5L4","L1L1","L3L1","L4L1","L5L1","L6L1")
norm_counts <- merge(feature_annotation,norm.expr, by="GeneID")
write.csv(norm_counts,file="All_normalized_genes.csv", quote=FALSE, row.names = FALSE)

##########
#PCA PLOT
##########
#setwd("~/Desktop/core-projects/22-1ELSI-001/DESEQ2")

setwd("/Users/shahina/Projects/22-1ELSI-001/DESEQ2")

#gernate rlog for PCA

  rld <-rlog(dds,blind=FALSE)
tiff("PCA_for_3_groups.tiff",res=600, width = 7, height = 7, units = 'in')
  nudge <- position_nudge(y = 0.5)
  p <- plotPCA(rld,intgroup=c("sample_group"))  
  p <- p + geom_text(aes_string(label = "name"), color="black", position = nudge, size=2.4)
p
dev.off()

tiff("PCA_for_3_groups_without_labels.tiff",res=600, width = 7, height = 7, units = 'in')
  #rld <-rlog(dds,blind=FALSE)
  nudge <- position_nudge(y = 0.5)
  p <- plotPCA(rld,intgroup=c("sample_group"))  
  #p <- p + geom_text(aes_string(label = "name"), color="black", position = nudge, size=2.4)
p
dev.off()

dds_wald <- DESeq(dds, betaPrior=FALSE, minReplicatesForReplace=Inf)

res_D4_vs_D1 <- results(dds_wald, contrast=c("sample_group","D4","D1" ))
res_LPS_vs_D1 <- results(dds_wald, contrast=c("sample_group","LPS","D1" ))
res_LPS_vs_D4 <- results(dds_wald, contrast=c("sample_group","LPS","D4" ))



#########
#BOX PLOT
#########
boxplot(log10(assays(dds_wald)[["cooks"]]), range=0, las=2)


#Differential Expression Analysis for 2 groups with pvalue less than 0.05
#resLFC_shrunken_D1_D4 <- lfcShrink(dds_wald, contrast=c("sample_group","D4","D1"), type="normal")
#resLFC_shrunken_D1_LPS <- lfcShrink(dds_wald, contrast=c("sample_group","LPS","D1"),  type="normal")

#resultsNames(dds_wald)
#[1] "Intercept"              "sample_group_D4_vs_D1"  "sample_group_LPS_vs_D1"
#resLFC_shrunken_D1_D4 <- lfcShrink(dds_wald, coef="sample_group_D4_vs_D1", type="apeglm")
#resLFC_shrunken_D1_LPS <- lfcShrink(dds_wald, coef="sample_group_LPS_vs_D1",  type="apeglm")
#resLFC_shrunken_LPS_D4 <- lfcShrink(dds_wald, coef=c("sample_group","LPS","D4"),  type="apeglm")


#Differential Expression Analysis for 2 groups with pvalue less than 0.05
#res_D1_D4 <- results(dds_wald  , contrast=c("sample_group","D1","D4"), alpha=0.05)
#res_D1_LPS <- results(dds_wald, contrast=c("sample_group","D1","LPS"), alpha=0.05)


#Summary of results
#summary(resLFC_shrunken_D1_D4, alpha=0.01)
#summary(resLFC_shrunken_D1_LPS, alpha=0.01)

#MA plot to see most significant genes
pdf("MAplot.pdf")
plotMA(res_D4_vs_D1, ylim=c(-2,2))
plotMA(res_LPS_vs_D1, ylim=c(-2,2))
plotMA(res_LPS_vs_D4, ylim=c(-2,2))
dev.off()

#summary(res)

df_for_all_genes <- function(contrast_DF,cond1,cond2){
 
  resDF1 <- data.frame(GeneID=rownames(contrast_DF),contrast_DF)
  resDF1 <- merge(feature_annotation,resDF1, by="GeneID")
  #order on FDR
  resDF1 <- resDF1[order(resDF1$padj),]
  log2FC1 <- resDF1$log2FoldChange
  resDF1$Fold_Change = ifelse(log2FC1 > 0, 2 ^ log2FC1, -1 / (2 ^ log2FC1))
  write.csv(resDF1,file=sprintf("DESEQ2_res_%s_%s_all_genes.csv",cond1,cond2), quote=FALSE, row.names = FALSE)
  return(resDF1)
 }

D1_D4_DF <- df_for_all_genes(res_D4_vs_D1,"D1","D4")
D1_LPS_DF <- df_for_all_genes(res_LPS_vs_D1,"D1","LPS")
D4_LPS_DF <- df_for_all_genes(res_LPS_vs_D4,"D4","LPS")


#resDF1 <- resDF[resDF$pvalue <= 0.05,]
#res_pval_ordered <- resDF1[order(resDF1$pvalue),]
#write.csv(res_pval_ordered,file="DESEQ2_res_D1_D4_at_pvalue_0.05.csv",quote=FALSE, row.names = FALSE)
#All significant at FDR 0.01
#resDF2 <- resDF[resDF$padj <= 0.01,]
#res_padj_ordered1 <- resDF2[order(resDF2$padj),]
#remove rows with all NAs
#res_padj_ordered1 <- res_padj_ordered1[rowSums(is.na(res_padj_ordered1)) != ncol(res_padj_ordered1), ]


#volcano plot
#remove rows if padj is NA
#d1d4_df <- res_padj_ordered1[!is.na(res_padj_ordered1$padj), ]
##assign up and down regulation and non signif based on log2fc
#d1d4_df$direction <- ifelse(as.numeric(d1d4_df$log2FoldChange) < -4, "down_regulated", 
#                                   ifelse(as.numeric(d1d4_df$log2FoldChange) > 4, "up_regulated", "signif" ))
  
#pdf("D1_D4_Volcano_plot_padj0.01_and_log2FC_4.pdf")
#  p <- ggplot(d1d4_df, aes(as.numeric(log2FoldChange), -log10(as.numeric(padj)))) +
#    geom_point(aes(col=direction),size=0.4,show.legend = FALSE) +
#    scale_color_manual(values=c("blue", "gray", "red")) +
#    theme(axis.text.x = element_text(size=11),
#          axis.text.y = element_text(size=11),
#          text = element_text(size=11)) +
#    xlab("log2(FC)") +
#    ylab("-log10(FDR)") 

  #order up and down on lowest adj pvalue
#  up <- d1d4_df[d1d4_df$direction == "up_regulated",]
#  up_ordered <- up[order(up$padj),]
#  down <- d1d4_df[d1d4_df$direction == "down_regulated",]
#  down_ordered <- down[order(down$padj),]
  
#  p1 <- p + geom_text_repel(data=head(up_ordered,10),aes(label=gene_name),size=2, box.padding = unit(0.7, "lines"), max.overlaps = Inf)
#  p2 <- p1 + geom_text_repel(data=head(down_ordered,10),aes(label=gene_name),size=2, box.padding = unit(0.7, "lines"), max.overlaps = Inf)
#  print(p2)
#dev.off()
  

#resDF1 <- resDF[resDF$pvalue <= 0.05,]
#res_pval_ordered <- resDF1[order(resDF1$pvalue),]
#write.csv(res_pval_ordered,file="DESEQ2_res_D1_LPS_at_pvalue_0.05.csv",quote=FALSE, row.names = FALSE)

#All significant at FDR 0.01
#resDF2 <- resDF[resDF$padj <= 0.01,]
#res_padj_ordered2 <- resDF2[order(resDF2$padj),]
#remove rows with all NAs
#res_padj_ordered2 <- res_padj_ordered2[rowSums(is.na(res_padj_ordered2)) != ncol(res_padj_ordered2), ]
#write.csv(res_padj_ordered2,file="DESEQ2_res_D1_LPS_at_fdr_0.01.csv",quote=FALSE, row.names = FALSE)


#volcano plot
#remove rows if padj is NA
#d1lps_df <- res_padj_ordered2[!is.na(res_padj_ordered2$padj), ]
#assign up and down regulation and non signif based on log2fc
#d1lps_df$direction <- ifelse(as.numeric(d1lps_df$log2FoldChange) < -4, "down_regulated", 
#                                 ifelse(as.numeric(d1lps_df$log2FoldChange) > 4, "up_regulated", "signif" ))

#pdf("D1_LPS_Volcano_plot_padj0.01_and_log2FC_4.pdf")
#p <- ggplot(d1lps_df, aes(as.numeric(log2FoldChange), -log10(as.numeric(padj)))) +
#  geom_point(aes(col=direction),size=0.4,show.legend = FALSE) +
#  scale_color_manual(values=c("blue", "gray", "red")) +
#  theme(axis.text.x = element_text(size=11),
#        axis.text.y = element_text(size=11),
#        text = element_text(size=11)) +
#  xlab("log2(FC)") +
#  ylab("-log10(FDR)") 

#order up and down on lowest adj pvalue
#up <- d1lps_df[d1lps_df$direction == "up_regulated",]
#up_ordered <- up[order(up$padj),]
#down <- d1lps_df[d1lps_df$direction == "down_regulated",]
#down_ordered <- down[order(down$padj),]

#p1 <- p + geom_text_repel(data=head(up_ordered,10),aes(label=gene_name),size=2, box.padding = unit(0.7, "lines"), max.overlaps = Inf)
#p2 <- p1 + geom_text_repel(data=head(down_ordered,10),aes(label=gene_name),size=2, box.padding = unit(0.7, "lines"), max.overlaps = Inf)
#print(p2)
#dev.off()



#resDF1 <- resDF[resDF$pvalue <= 0.05,]
#res_pval_ordered <- resDF1[order(resDF1$pvalue),]
#write.csv(res_pval_ordered,file="DESEQ2_res_D4_LPS_at_pvalue_0.05.csv",quote=FALSE, row.names = FALSE)

#All significant at FDR 0.01
#resDF2 <- resDF[resDF$padj <= 0.01,]
#res_padj_ordered3 <- resDF2[order(resDF2$padj),]
#remove rows with all NAs
#res_padj_ordered3 <- res_padj_ordered3[rowSums(is.na(res_padj_ordered3)) != ncol(res_padj_ordered3), ]

#write.csv(res_padj_ordered3,file="DESEQ2_res_D4_LPS_at_fdr_0.01.csv",quote=FALSE, row.names = FALSE)

#comman genes between three contrasts
#df_list <- list(res_padj_ordered1, res_padj_ordered2, res_padj_ordered3)

#merge all data frames in list
#comman_genes_at_fdr0.01 <- Reduce(function(x, y) merge(x, y, by="GeneID", suffix=c(".D4_vs_D1",".LPS_vs_D1")), df_list)

#colnames(comman_genes_at_fdr0.01)[2] <- "gene_name"
#comman_genes_at_fdr0.01 <- comman_genes_at_fdr0.01[c(-9,-16)]
#names(comman_genes_at_fdr0.01)[15:20] <- c("baseMean.LPS_vs_D4","log2FoldChange.LPS_vs_D4","lfcSE.LPS_vs_D4","stat.LPS_vs_D4","pvalue.LPS_vs_D4","padj.LPS_vs_D4")                                  
#write.csv(comman_genes_at_fdr0.01,file="comman_genes_at_fdr_0.01_three_contrasts.csv",quote=FALSE, row.names = FALSE)

#volcano plot
#remove rows if padj is NA
#d4lps_df <- res_padj_ordered3[!is.na(res_padj_ordered3$padj), ]
#assign up and down regulation and non signif based on log2fc
#d4lps_df$direction <- ifelse(as.numeric(d4lps_df$log2FoldChange) < -4, "down_regulated", 
#                                 ifelse(as.numeric(d4lps_df$log2FoldChange) > 4, "up_regulated", "signif" ))

#pdf("D4_LPS_Volcano_plot_padj0.01_and_log2FC_4.pdf")
#p <- ggplot(d4lps_df, aes(as.numeric(log2FoldChange), -log10(as.numeric(padj)))) +
#  geom_point(aes(col=direction),size=0.4,show.legend = FALSE) +
#  scale_color_manual(values=c("blue", "gray", "red")) +
#  theme(axis.text.x = element_text(size=11),
#        axis.text.y = element_text(size=11),
#        text = element_text(size=11)) +
#  xlab("log2(FC)") +
#  ylab("-log10(FDR)") 

#order up and down on lowest adj pvalue
#up <- d4lps_df[d4lps_df$direction == "up_regulated",]
#up_ordered <- up[order(up$padj),]
#down <- d4lps_df[d4lps_df$direction == "down_regulated",]
#down_ordered <- down[order(down$padj),]

#p1 <- p + geom_text_repel(data=head(up_ordered,10),aes(label=gene_name),size=2, box.padding = unit(0.7, "lines"), max.overlaps = Inf)
#p2 <- p1 + geom_text_repel(data=head(down_ordered,10),aes(label=gene_name),size=2, box.padding = unit(0.7, "lines"), max.overlaps = Inf)
#print(p2)
#dev.off()

###############
 #Venn Diagram                                 
###############                                

#library(eulerr) 
#Venn diagram for 2 contast at fdr 0.01
#pdf("VennDiagram_at_fdr0.01_2contrast.pdf", width=10, height=3)
#D1_D4 <- res_padj_ordered1
#D1_LPS <- res_padj_ordered2

#s1 <- list(D4_vs_D1 = D1_D4$GeneID,
#           LPS_vs_D1 = D1_LPS$GeneID)
##Total genes common between two contrast
#plot(euler(s1, shape = "circle"), quantities = TRUE, fill=yarrr::transparent(c('palegreen1','salmon2'), .1),main="All genes (up and down regulated)")

#log2FC <- D1_D4$log2FoldChange
#D1_D4$Fold_Change = ifelse(log2FC > 0, 2 ^ log2FC, -1 / (2 ^ log2FC))

#log2FC1 <- D1_LPS$log2FoldChange
#D1_LPS$Fold_Change = ifelse(log2FC1 > 0, 2 ^ log2FC1, -1 / (2 ^ log2FC1))

#Up regulated Genes common between two contrast
#D1_D4_up <- D1_D4[D1_D4$Fold_Change >= 0,]$GeneID 
#D1_LPS_up <- D1_LPS[D1_LPS$Fold_Change >= 0,]$GeneID 

#s2 <- list(D4_vs_D1 = D1_D4_up,
#           LPS_vs_D1 = D1_LPS_up)

#plot(euler(s2, shape = "circle"), quantities = TRUE, fill=yarrr::transparent(c('palegreen1','salmon2'), .1) ,main="Up regulated")

#Down regulated genes common between two contrast
#D1_D4_down <- D1_D4[D1_D4$Fold_Change < 0,]$GeneID 
#D1_LPS_down <- D1_LPS[D1_LPS$Fold_Change < 0,]$GeneID 

#s3 <- list(D4_vs_D1 = D1_D4_down,
#           LPS_vs_D1 = D1_LPS_down)

#plot(euler(s3, shape = "circle"), quantities = TRUE, fill=yarrr::transparent(c('palegreen1','salmon2'), .1),main="Down regulated")

#dev.off()


#Venn diagram for 2 contast at fdr 0.01 and FC +/-10                                  
#pdf("VennDiagram_at_fdr0.01_and_fc10_2contrast.pdf", width=10, height=3)
#D1_D4 <- res_padj_ordered1
#D1_LPS <- res_padj_ordered2
                                  
#log2FC <- D1_D4$log2FoldChange
#D1_D4$Fold_Change = ifelse(log2FC > 0, 2 ^ log2FC, -1 / (2 ^ log2FC))

#log2FC1 <- D1_LPS$log2FoldChange
#D1_LPS$Fold_Change = ifelse(log2FC1 > 0, 2 ^ log2FC1, -1 / (2 ^ log2FC1))

#D1_D4_df <- c(D1_D4[D1_D4$Fold_Change >= 10,]$GeneID, D1_D4[D1_D4$Fold_Change <= -10,]$GeneID)  
#D1_LPS_df <- c(D1_LPS[D1_LPS$Fold_Change >= 10,]$GeneID, D1_LPS[D1_LPS$Fold_Change <= -10,]$GeneID)                          
                                  
#s2 <- list(D4_vs_D1 = D1_D4_df, LPS_vs_D1 = D1_LPS_df)

#plot(euler(s2, shape = "circle"), quantities = TRUE, fill=yarrr::transparent(c('palegreen1','salmon2'), .1) ,main="FDR=0.01 AND FOLDCHANGE +/-10")                                 
#dev.off()
                                  
#Venn diagram for 3 contast at fdr 0.01 and FC +/-10                                  
#pdf("VennDiagram_at_fdr0.01_and_fc10_3contrast.pdf", width=10, height=3)
#D1_D4 <- res_padj_ordered1
#D1_LPS <- res_padj_ordered2
#D4_LPS <- res_padj_ordered3                                 
                                  
#log2FC <- D1_D4$log2FoldChange
#D1_D4$Fold_Change = ifelse(log2FC > 0, 2 ^ log2FC, -1 / (2 ^ log2FC))

#log2FC1 <- D1_LPS$log2FoldChange
#D1_LPS$Fold_Change = ifelse(log2FC1 > 0, 2 ^ log2FC1, -1 / (2 ^ log2FC1))
                                  
#log2FC1 <- D4_LPS$log2FoldChange
#D4_LPS$Fold_Change = ifelse(log2FC1 > 0, 2 ^ log2FC1, -1 / (2 ^ log2FC1))
                                  
#D1_D4_df <- c(D1_D4[D1_D4$Fold_Change >= 10,]$GeneID, D1_D4[D1_D4$Fold_Change <= -10,]$GeneID)
#D1_LPS_df <- c(D1_LPS[D1_LPS$Fold_Change >= 10,]$GeneID, D1_LPS[D1_LPS$Fold_Change <= -10,]$GeneID)                          
#D4_LPS_df <- c(D4_LPS[D4_LPS$Fold_Change >= 10,]$GeneID, D4_LPS[D4_LPS$Fold_Change <= -10,]$GeneID)  
                                  
#s2 <- list(D4_vs_D1 = D1_D4_df, LPS_vs_D1 = D1_LPS_df, LPS_vs_D4=D4_LPS_df)

#plot(euler(s2, shape = "circle"), quantities = TRUE, fill=yarrr::transparent(c('palegreen1','salmon2','seashell3'), .1) ,main="FDR=0.01 AND FOLDCHANGE +/-10")                                   
#dev.off()                                  
                              
###############
#  COUNT PLOT                   
################                              
                                                                                    
library(ggtree)
#plot count top 10 differntially expressed genes for D4 vs D1

pdf("count_plot_D1_D4_with_normalization.pdf", height=20, width=15)
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
                                 

pdf("count_plot_D1_LPS_with_normalization.pdf", height=20, width=15)
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
                                  
pdf("count_plot_D4_LPS_with_normalization.pdf", height=20, width=15)
gene_ids = head(res_padj_ordered3$GeneID, 10)
myplots <- list()  # new empty list
for (gene in gene_ids)
{
  d <- plotCounts(dds_wald, gene= gene, 
                  intgroup="sample_group", returnData=TRUE)
  
  p <- ggplot(d, aes(x=sample_group, y=count)) + 
    geom_point(position=position_jitter(w=0.1,h=0)) + 
    ylab("Normalized Count") +
    #scale_y_log10(breaks=c(100,1000,3000,6000)) +
    ggtitle(paste(gene,":",res_padj_ordered3[res_padj_ordered3$GeneID==gene,]$gene_name,": FDR ",res_padj_ordered3[res_padj_ordered3$GeneID==gene,]$padj))
  
  myplots[[gene]] <- p 
  
}
multiplot(plotlist = myplots, ncol = 2)

dev.off()
                                  
#Get normalized count (used for plot count) for genes at fdr 0.01             
D1_D4 <- filter(D1_D4_DF, padj <= 0.01)
D1_LPS <- filter(D1_LPS_DF, padj <= 0.01)
D4_LPS <- filter(D4_LPS_DF, padj <= 0.01)
                                  
get_normalized_counts <- function(df,contrast) {
  df <- df[order(df$padj),]
  gene_ids = df$GeneID
  for (gene in gene_ids)
  {
    normalized_count <- plotCounts(dds_wald, gene=gene, intgroup="sample_group", returnData=TRUE)
    normalized_count <- as.numeric(t(normalized_count)[1,])
    normalized_count <- c(gene,normalized_count)
    normalized_count <- t(normalized_count)
    colnames(normalized_count) <- c("GeneID","E1L1","E2L1","E3L1","E4L1","E5L1","E1L4","E2L4","E3L4","E4L4","E5L4","L1L1","L3L1","L4L1","L5L1","L6L1")
    normalized_count <- merge(df[1:2],normalized_count, by="GeneID")
    names(normalized_count) <- NULL
    write.table(normalized_count, file=paste(contrast,"_with_norm_counts.csv"),quote=FALSE, row.names = FALSE,sep=",", append=TRUE)
  }
}
#col.names=!file.exists(paste(contrast,"_with_norm_counts_at_fdr0.01.csv"))
get_normalized_counts(D1_D4,"D1_D4")  
get_normalized_counts(D1_LPS,"D1_LPS")                                  
get_normalized_counts(D4_LPS,"D4_LPS")                                  


add_column_names <- function(norm_df){
    df <- read.csv(paste(norm_df,"_with_norm_counts.csv"), header=FALSE)
    colnames(df) <- c("GeneID","GeneName","E1L1","E2L1","E3L1","E4L1","E5L1","E1L4","E2L4","E3L4","E4L4","E5L4","L1L1","L3L1","L4L1","L5L1","L6L1")
    write.table(df, file=paste(norm_df,"_with_norm_counts-1.csv"),quote=FALSE, row.names = FALSE,sep=",")

}
add_column_names("D1_D4")  
add_column_names("D1_LPS")                                  
add_column_names("D4_LPS")  


#take top 2000 genes based on FDR
write.csv(head(D1_D4,2000), "D1_D4_2000genes_with_lowestFDR.csv", quote=FALSE, row.names = FALSE)
write.csv(head(D1_LPS,2000), "D1_LPS_2000genes_with_lowestFDR.csv", quote=FALSE, row.names = FALSE)
write.csv(head(D4_LPS,2000), "D4_LPS_2000genes_with_lowestFDR.csv", quote=FALSE, row.names = FALSE)


library(VennDiagram)
library(RColorBrewer)

myCol <- brewer.pal(3, "Pastel2")
#venn diagram on raw data (three conditions)
#keep gene if any of the condition has value for any 1 sample
f1 <- feature_count[1:5] %>% 
  filter(if_any(c(1:5), ~ . >=1))

f2 <- feature_count[6:10] %>% 
  filter(if_any(c(1:5), ~ . >=1))
 
f3 <- feature_count[11:15] %>% 
  filter(if_any(c(1:5), ~ . >=1))                                 
                                                        
D1 <- rownames(f1)
D4 <- rownames(f2)
LPS <- rownames(f3)                                
 

display_venn <- function(x, ...){
  library(VennDiagram)
  grid.newpage()
  venn_object <- venn.diagram(x, filename = NULL, ...)
  grid.draw(venn_object)
}                                  
                                  
pdf("VennDiagram_based_on_rawdata.pdf")                                  
  display_venn(
      list(D1=D1,D4=D4,LPS=LPS),
      category.names = c("D1" , "D4" , "LPS"),
      fill = c("#999999", "#E69F00", "#56B4E9")
  )                                 
dev.off()
                                  
 #venn.diagram(
 # x <- list(D1=D1,D4=D4,LPS=LPS),
 # filename = 'VennDiagram_based_on_rawdata.tiff',
 # category.names = c("D1","D4","LPS"),
 # output=TRUE,
  # Circles
#  lwd = 2,
#  lty = 'blank',
#  fill = myCol)   
                                  
                                  
#Get normalized count for differentially expressed genes at fdr 0.01
#select <- order(rowMeans(counts(dds_wald,normalized=TRUE)),decreasing=FALSE)[1:nrow(counts(dds_wald))]
#nt <- normTransform(dds_wald)
#log2.norm.counts <- assay(nt)[select,]
#log2.norm.counts<- as.data.frame(log2.norm.counts)
#log2.norm.counts <- cbind(GeneID=rownames(log2.norm.counts), log2.norm.counts)

#D1 vs D4
#D1_D4_with_norm_counts <- merge(D1_D4,log2.norm.counts, by="GeneID")
#colnames(D1_D4_with_norm_counts)[8:22] <- c("E1L1","E2L1","E3L1","E4L1","E5L1","E1L4","E2L4","E3L4","E4L4","E5L4","L1L1","L3L1","L4L1","L5L1","L6L1")
#write.csv(D1_D4_with_norm_counts,file="D1_D4_with_norm_counts_at_fdr0.01.csv",quote=FALSE, row.names = FALSE)
               

