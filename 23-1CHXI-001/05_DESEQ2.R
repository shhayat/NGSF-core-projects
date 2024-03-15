setwd("/Users/shahina/Projects/23-1CHXI-001")

library("DESeq2")
library("ggplot2")
library("xlsx")

dir.create("DESEQ2", recursive=TRUE, showWarnings = FALSE) 

load("feature_count.RData")
feature_count <- as.data.frame(feature_count)

#your first columns which are gene id and gene name
feature_annotation <- data.frame(GeneID=feature_count$GeneID,gene_name=feature_count[2])
colnames(feature_count) <- c("GeneID","gene_name","H17","H18","H19","H20","H21","H22","C18","C19","C20","C21","C22","C23")
feature_count <- feature_count[rowSums(feature_count[,c(3:ncol(feature_count))])>0, ]

  write.xlsx(feature_count,file="DESEQ2/raw_counts.xlsx", row.names = FALSE)

DEG_analysis <-  function(colnum,cond1, cond2, ref, rep_cond1,rep_cond2,str)
{
  feature_count <- feature_count[colnum]
  #remove row with sum zero
  feature_count <- feature_count[rowSums(feature_count[,c(1:ncol(feature_count))])>0, ]
  
  sampleInfo=data.frame(sample_name=dput(as.character(names(feature_count))),
                        sample_type=dput(as.character(names(feature_count))),
                        sample_group=dput(as.character(c(rep(cond1,rep_cond1),rep(cond2,rep_cond2)))))
  
  
  
  group <- data.frame(sample_group=sampleInfo$sample_group)
  
  dds <- DESeqDataSetFromMatrix(countData=feature_count,
                                colData=group,
                                design=~sample_group)
  
  
  dds$sample_group <-relevel(dds$sample_group,ref=ref)
  
  ##########
  #PCA PLOT
  ##########
  #gernate rlog for PCA
  #rld <-rlog(dds,blind=FALSE)
  #pdf(sprintf("PCA_%s_%s_%s.pdf",cond2,cond1,str), width=8,height=8)
  #  nudge <- position_nudge(y = 0.5)
  #  p <- plotPCA(rld,intgroup=c("sample_group"))  
  #  p <- p + geom_text(aes_string(label = "name"), color="black", position = nudge, size=2.8)
  #  print(p)
  #dev.off()
  
  dds_wald <- DESeq(dds, betaPrior=FALSE, minReplicatesForReplace=Inf)
  res <- results(dds_wald, contrast=c("sample_group",cond2,cond1))
  
  resDF <- data.frame(GeneID=rownames(res),res)
  resDF <- merge(feature_annotation,resDF, by="GeneID")
  resDF <- resDF[order(resDF$pvalue),]
  log2FC <- resDF$log2FoldChange
  resDF$Fold_Change = ifelse(log2FC > 0, 2 ^ log2FC, -1 / (2 ^ log2FC))

  resDF1 <- resDF[resDF$pvalue <= 0.05,]
  
  #write.xlsx(resDF1,file=sprintf("DESEQ2/DEG_%s_vs_%s_%s.xlsx",cond2,cond1, str), row.names = FALSE)
  write.xlsx(resDF,file=sprintf("DESEQ2/DEG_%s_vs_%s_%s_all_genes.xlsx",cond2,cond1, str), row.names = FALSE)

  dds <- estimateSizeFactors(dds)
  norm.expr <- counts(dds, normalized=TRUE)
  norm.expr <- as.data.frame(norm.expr)
  norm.expr <- data.frame(rownames(norm.expr),norm.expr)
  colnames(norm.expr) <- c("GeneID","H17","H18","H19","H20","H21","H22","C18","C19","C20","C21","C22","C23")
  norm_counts <- merge(feature_annotation,norm.expr, by="GeneID")
  write.xlsx(norm_counts,file="DESEQ2/DEG_normalized_counts.xlsx", row.names = FALSE)

}
DEG_analysis(c(9,10,11,12,13,14,3,4,5,6,7,8),"CONTROL","HFD","CONTROL",6,6, "all_sample")
#DEG_analysis(c(10,11,13,14,4,5,6,7,8),"CONTROL","HFD","CONTROL",4,5,"filtered_sample")




#################
#volcano plot
#################
setwd("/Users/shahina/Projects/2023_projects/23-1CHX1-001/")

library(ggplot2)
#res <- read.csv("DESEQ2/DEG_HFD_vs_CONTROL_all_sample.csv")
res <- read.csv("DESEQ2/DEG_HFD_vs_CONTROL_all_sample_all_genes.csv")
res1 <- as.data.frame(res)

#assign up and down regulation and non signif based on log2fc
res1$direction <- ifelse(res1$log2FoldChange < -1, "down_regulated", 
                         ifelse(res1$log2FoldChange > 1, "up_regulated", "signif" ))

res1 <- res1[!is.na(res1$pvalue), ]

tiff("Volcano_plot_with_pvalue.tiff",res=600, width = 7, height = 7, units = 'in')
#png("/Users/shahina/Projects/20-1JOHO-001/plots/Volcano_plot_with_pvalue.png", width=1300, height=500, res=120)

ggplot(res1, aes(log2FoldChange, -log10(as.numeric(pvalue)))) +
  geom_point(aes(col=direction),
             size=0.8,
             show.legend = FALSE) +
  scale_color_manual(values=c("blue", "gray", "red")) +
  theme(axis.text.x = element_text(size=11),
        axis.text.y = element_text(size=11),
        text = element_text(size=11)) +
        xlab("log2(Fold Change)") +
        ylab("-log10(Pvalue)") + theme_bw() +
        theme(panel.border = element_blank(), panel.grid.major = element_blank(),panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
  #annotate("text",x=2.2,y=1.7,hjust = 0,label=" Total (FDR <=0.05) = 6678 \n Total Upregulated = 3138 \n Total Down Regulated = 3540 \n Log2FC > 1 = 120 \n Log2FC < -1 = 90", size = 3)  +
dev.off()


res2 <- res1[!(res1$padj=="#N/A"),]
tiff("Volcano_plot_with_fdr.tiff",res=600, width = 7, height = 7, units = 'in')
#png("/Users/shahina/Projects/20-1JOHO-001/plots/Volcano_plot_with_pvalue.png", width=1300, height=500, res=120)

ggplot(res2, aes(log2FoldChange, -log10(as.numeric(padj)))) +
  geom_point(aes(col=direction),
             size=0.8,
             show.legend = FALSE) +
  scale_color_manual(values=c("blue", "gray", "red")) +
  theme(axis.text.x = element_text(size=11),
        axis.text.y = element_text(size=11),
        text = element_text(size=11)) +
        xlab("log2(Fold Change)") +
        ylab("-log10(fdr)") + theme_bw() +
        theme(panel.border = element_blank(), panel.grid.major = element_blank(),panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
  #annotate("text",x=2.2,y=1.7,hjust = 0,label=" Total (FDR <=0.05) = 6678 \n Total Upregulated = 3138 \n Total Down Regulated = 3540 \n Log2FC > 1 = 120 \n Log2FC < -1 = 90", size = 3)  +
dev.off()




library("DESeq2")
library("ggplot2")
library("xlsx")

dir.create("DESEQ2", recursive=TRUE, showWarnings = FALSE) 

load("feature_count.RData")
feature_count <- as.data.frame(feature_count)

#your first columns which are gene id and gene name
feature_annotation <- data.frame(GeneID=feature_count$GeneID,gene_name=feature_count[2])
colnames(feature_count) <- c("GeneID","gene_name","H17","H18","H19","H20","H21","H22","C18","C19","C20","C21","C22","C23")
feature_count <- feature_count[rowSums(feature_count[,c(3:ncol(feature_count))])>0, ]

  write.xlsx(feature_count,file="DESEQ2/raw_counts.xlsx", row.names = FALSE)

DEG_analysis <-  function(colnum,cond1, cond2, ref, rep_cond1,rep_cond2,str)
{
  feature_count <- feature_count[colnum]
  #remove row with sum zero
  feature_count <- feature_count[rowSums(feature_count[,c(1:ncol(feature_count))])>0, ]
  
  sampleInfo=data.frame(sample_name=dput(as.character(names(feature_count))),
                        sample_type=dput(as.character(names(feature_count))),
                        sample_group=dput(as.character(c(rep(cond1,rep_cond1),rep(cond2,rep_cond2)))))
  
  
  group <- data.frame(sample_group=sampleInfo$sample_group)
  
  dds <- DESeqDataSetFromMatrix(countData=feature_count,
                                colData=group,
                                design=~sample_group)
  
  
  dds$sample_group <-relevel(dds$sample_group,ref=ref)
  
  dds_wald <- DESeq(dds, betaPrior=FALSE, minReplicatesForReplace=Inf)
  res <- results(dds_wald, contrast=c("sample_group",cond2,cond1))
  
  resDF <- data.frame(GeneID=rownames(res),res)
  resDF <- merge(feature_annotation,resDF, by="GeneID")
  resDF <- resDF[order(resDF$pvalue),]
  log2FC <- resDF$log2FoldChange
  resDF$Fold_Change = ifelse(log2FC > 0, 2 ^ log2FC, -1 / (2 ^ log2FC))

  resDF1 <- resDF[resDF$pvalue <= 0.05,]


nt <- normTransform(dds_wald)
log2.norm.counts <- assay(nt)[select,]
log2.norm.counts<- as.data.frame(log2.norm.counts)
                     
log2.norm.counts1 <- data.frame(Gene=feature_count1$gene_name, log2.norm.counts)
colnames(log2.norm.counts1) <- c("Gene",names(feature_count1[,3:26]))
#DF <- rbind(select_up_cols,select_down_cols)
#DF <- DF[complete.cases(DF), ]
#log2.norm.counts1 <- merge(DF,log2.norm.counts1, by=c("GeneID"))
log2.norm.counts2 <- log2.norm.counts1[,-1]
rownames(log2.norm.counts2) <-  make.names(log2.norm.counts1[,1],TRUE)
bwcolor = grDevices::colorRampPalette(c("yellow","grey", "blue"))

##########
#HEATMAP
##########
setwd("/Users/shahina/Projects/23-1CHXI-001")

library("DESeq2")
library("ggplot2")
library("xlsx")
library("pheatmap")


load("feature_count.RData")
feature_count <- as.data.frame(feature_count)

#your first columns which are gene id and gene name
feature_annotation <- data.frame(GeneID=feature_count$GeneID,gene_name=feature_count[2])
feature_count1 <- feature_count[c(9,10,11,12,13,14,3,4,5,6,7,8)]
  
  sampleInfo=data.frame(sample_name=dput(as.character(names(feature_count1))),
                        sample_type=dput(as.character(names(feature_count1))),
                        sample_group=dput(as.character(c(rep("CONTROL",6),rep("HFD",6)))))
  
  
  group <- data.frame(sample_group=sampleInfo$sample_group)
  
  dds <- DESeqDataSetFromMatrix(countData=feature_count1,colData=group,design=~sample_group)
  
  dds$sample_group <-relevel(dds$sample_group,ref="CONTROL")

  dds <- estimateSizeFactors(dds)
  norm.expr <- counts(dds, normalized=TRUE)
  norm.expr <- as.data.frame(norm.expr)
     
norm.expr <- data.frame(Gene=feature_count$gene_name, norm.expr)
colnames(norm.expr) <- c("Gene",names(feature_count1[,1:12]))

norm.expr <- norm.expr[grep("^(AP2M1|APOA4|APOC2|CLTA|CLTC|CREB3L3|CUBN|HDLBP|LDLR|LIPA|MTTP|P4HB|RPS27A|SAR1B|UBC|ACOX1|ACOX2|ALDH3A2|HSD17B4|SCP2|ACAA1|ACAA2|ACSL3|CPT1A|PLIN2|PLIN3)$", norm.expr$Gene,ignore.case = TRUE), ]
  
rownames(norm.expr) <-  make.names(norm.expr[,1],TRUE)
colnames(norm.expr) <- c("Gene","C18","C19","C20","C21","C22","C23","H17","H18","H19","H20","H21","H22")  
norm.expr <- norm.expr[,-1]

bwcolor = grDevices::colorRampPalette(c("yellow","grey", "blue"))

  
pdf("Heatmap.pdf")
pheatmap(
      norm.expr,
      clustering_dist_rows = "correlation",
      scale      = 'row',
      cellheight = 8,
      cellwidth =  8,
      fontsize   = 6,
      col = bwcolor(50),
      treeheight_row = 0,
      treeheight_col = 0,
      cluster_cols = FALSE,
      border_color = NA)
dev.off()

