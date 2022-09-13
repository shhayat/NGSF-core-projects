library("DESeq2")
library("ggplot2")
library("dplyr")

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

#Volcano Plot
pdf("core-projects/22-1ELSI-001/DESEQ2/D1_D4_Volcano_plot_padj0.01_and_log2FC_4.pdf")
alpha=0.01
resDF$sig <- -log10(resDF$padj)
sum(is.infinite(resDF$sig))

cols <- densCols(resDF$log2FoldChange, resDF$sig)
cols[resDF$padj ==0] <- "purple"
resDF$pch <- 19
resDF$pch[resDF$pvalue ==0] <- 6
plot(resDF$log2FoldChange, 
     resDF$sig, 
     col=cols, panel.first=grid(),
     main="Volcano plot", 
     xlab="Effect size: log2(fold-change)",
     ylab="-log10(adjusted p-adj)",
     pch=resDF$pch, cex=0.4)
abline(v=0)
abline(v=c(-1,1), col="brown")
abline(h=-log10(alpha), col="brown")

## Plot the names of a reasonable number of genes, by selecting those begin not only significant but also having a strong effect size
gn.selected <- abs(resDF$log2FoldChange) > 4 & resDF$padj < alpha 
text(resDF$log2FoldChange[gn.selected],
     -log10(resDF$padj)[gn.selected],
     lab=resDF$gene_name[gn.selected], cex=0.4)

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


#Volcano Plot
#pdf("D1_LPS_Volcano_plot_padj0.01_and_log2FC_4.pdf")
#alpha=0.01
#resDF$sig <- -log10(resDF$padj)
#sum(is.infinite(resDF$sig))



plot_volcano <- function(condition_df, condition_name){
  
  #colnames(condition_df) <- as.character(condition_df[1,])
  #condition_df <- condition_df[-1,]
  
  #remove rows if padj is NA
  condition_df <- condition_df[!is.na(condition_df$padj), ]
  #assign up and down regulation and non signif based on log2fc
  condition_df$direction <- ifelse(as.numeric(condition_df$log2FoldChange) < -4, "down_regulated", 
                                   ifelse(as.numeric(condition_df$log2FoldChange) > 4, "up_regulated", "signif" ))
  
  pdf(paste0(condition_name,"_Volcano_plot_padj0.01_and_log2FC_4.pdf"))
  ggplot(condition_df, aes(as.numeric(log2FoldChange), -log10(as.numeric(padj)))) +
    geom_point(aes(col=direction),size=0.4,show.legend = FALSE) +
    scale_color_manual(values=c("blue", "gray", "red")) +
    theme(axis.text.x = element_text(size=11),
          axis.text.y = element_text(size=11),
          text = element_text(size=11)) +
    xlab("log2(FC)") +
    ylab("-log10(FDR)") 

  dev.off()
}



#Volcano Plot
pdf("core-projects/22-1ELSI-001/DESEQ2/D1_LPS_Volcano_plot_padj0.01_and_log2FC_4.pdf")
alpha=0.01
resDF$sig <- -log10(resDF$padj)
sum(is.infinite(resDF$sig))

cols <- densCols(resDF$log2FoldChange, resDF$sig)
cols[resDF$padj ==0] <- "purple"
resDF$pch <- 19
resDF$pch[resDF$pvalue ==0] <- 6
plot(resDF$log2FoldChange, 
     resDF$sig, 
     col=cols, panel.first=grid(),
     main="Volcano plot", 
     xlab="Effect size: log2(fold-change)",
     ylab="-log10(adjusted p-adj)",
     pch=resDF$pch, cex=0.4)
abline(v=0)
abline(v=c(-1,1), col="brown")
abline(h=-log10(alpha), col="brown")

## Plot the names of a reasonable number of genes, by selecting those begin not only significant but also having a strong effect size
gn.selected <- abs(resDF$log2FoldChange) > 4 & resDF$padj < alpha 
text(resDF$log2FoldChange[gn.selected],
     -log10(resDF$padj)[gn.selected],
     lab=resDF$gene_name[gn.selected], cex=0.4)

dev.off()
