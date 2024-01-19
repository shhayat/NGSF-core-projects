setwd("/Users/shahina/Projects/23-1SCWI-001")

library("DESeq2")
library("ggplot2")
library("xlsx")

dir.create("DESEQ2", recursive=TRUE, showWarnings = FALSE) 

load("feature_count.RData")
feature_count <- as.data.frame(feature_count)
colnames(feature_count) <- c("geneID","gene_name","1M","2M","3M","4M","5M","6M","7M","8M","9M","10M","11M","12M",
                            "1F","2F","3F","4F","5F","6F","7F","8F","9F","10F","11F","12F")
#remove number after decimal point from ensembl ID
geneID <- gsub(".[0-9]*$", "", rownames(feature_count))
rownames(feature_count) <- geneID

#your first columns which are gene id and gene name
feature_annotation <- data.frame(GeneID=geneID,gene_name=feature_count[2])


DEG_analysis <-  function(colnum,cond1, cond2, ref, rep_cond1,rep_cond2, str,str1)
{
  feature_count <- feature_count[colnum]
  #remove row with sum zero
  feature_count <- feature_count[rowSums(feature_count[,c(1:ncol(feature_count))])>1, ]
  
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
  #pdf(sprintf("PCA_%s_%s_%s_%s.pdf",cond2,cond1,str,str1), width=8,height=8)
  # nudge <- position_nudge(y = 0.8)
  # p <- plotPCA(rld,intgroup=c("sample_group"))  
  # p <- p + geom_text(aes_string(label = "name"), color="black", position = nudge, size=2.8)
  # print(p)
  #dev.off()
  
  dds_wald <- DESeq(dds, betaPrior=FALSE, minReplicatesForReplace=Inf)
  res <- results(dds_wald, contrast=c("sample_group",cond2,cond1))
  
  resDF <- data.frame(GeneID=rownames(res),res)
  resDF <- merge(feature_annotation,resDF, by="GeneID")
  resDF <- resDF[order(resDF$pvalue),]
  log2FC <- resDF$log2FoldChange
  resDF$Fold_Change = ifelse(log2FC > 0, 2 ^ log2FC, -1 / (2 ^ log2FC))

  #resDF1 <- resDF[resDF$pvalue <= 0.05,]
  #All Genes
  write.xlsx(resDF,file=sprintf("DESEQ2/DEG_%s_vs_%s_all_genes.xlsx",cond2,cond1), row.names = FALSE)

}
DEG_analysis(c(4,7,10,13,16,19,22,25,3,6,9,12,15,18,21,24),"GFP","CRE","GFP",8,8,"Males_Females","all_samples")
DEG_analysis(c(4,7,10,13,16,19,22,25,5,8,11,14,17,20,23,26),"GFP","HnRF1","GFP",8,8,"Males_Females","all_samples")

#DEG_analysis(c(4,7,10,13,3,6,9,12),"GFP","CRE","GFP",4,4,"Males","all_samples")
#DEG_analysis(c(16,19,22,25,15,18,21,24),"GFP","CRE","GFP",4,4,"Females","all_samples")

#DEG_analysis(c(4,7,10,13,5,8,11,14),"GFP","HnRF1","GFP",4,4,"Males","all_samples")
#DEG_analysis(c(7,10,13,5,14),"GFP","HnRF1","GFP",3,2,"Males","filtered")
#DEG_analysis(c(16,19,22,25,17,20,23,26),"GFP","HnRF1","GFP",4,4,"Females","all_samples")



library(pheatmap)
#HEATMAP
load("feature_count.RData")
feature_count <- as.data.frame(feature_count)
colnames(feature_count) <- c("geneID","gene_name","1M_CRE","2M_CRE","3M_CRE","4M_CRE","5M_CRE","6M_CRE","7M_CRE","8M_CRE",
                             "9M_GFP","10M_GFP","11M_GFP","12M_GFP","1F_GFP","2F_GFP","3F_GFP","4F_GFP",
                             "5F_HnRF1","6F_HnRF1","7F_HnRF1","8F_HnRF1","9F_HnRF1","10F_HnRF1","11F_HnRF1","12F_HnRF1")
#remove number after decimal point from ensembl ID
geneID <- gsub(".[0-9]*$", "", rownames(feature_count))
rownames(feature_count) <- geneID

feature_count <- feature_count[c(2,3,6,9,12,15,18,21,24,4,7,10,13,16,19,22,25,5,8,11,14,17,20,23,26)]
feature_count1 <- feature_count[rowSums(feature_count[,c(2:ncol(feature_count))])>3, ]

 sampleInfo=data.frame(sample_name=dput(as.character(names(feature_count1[2:25]))),
                        sample_type=dput(as.character(names(feature_count1[2:25]))),
                        sample_group=dput(as.character(c(rep("CRE",8),rep("GFP",8),rep("HnRF1",8)))))  
  
group <- data.frame(sample_group=sampleInfo$sample_group)
  
dds <- DESeqDataSetFromMatrix(countData=feature_count1[2:25],colData=group,design=~sample_group)
  
dds$sample_group <-relevel(dds$sample_group,ref="GFP")
  
dds_wald <- DESeq(dds, betaPrior=FALSE, minReplicatesForReplace=Inf)

select <- order(rowMeans(counts(dds_wald,normalized=TRUE)),decreasing=FALSE)[1:nrow(counts(dds_wald))]

nt <- normTransform(dds_wald)
log2.norm.counts <- assay(nt)[select,]
log2.norm.counts<- as.data.frame(log2.norm.counts)
                     
log2.norm.counts1 <- data.frame(Gene=feature_count1$gene_name, log2.norm.counts)
colnames(log2.norm.counts1) <- c("Gene",names(feature_count1[,2:25]))

#DF <- rbind(select_up_cols,select_down_cols)
#DF <- DF[complete.cases(DF), ]

#log2.norm.counts1 <- merge(DF,log2.norm.counts1, by=c("GeneID"))
log2.norm.counts2 <- log2.norm.counts1[,-1]

rownames(log2.norm.counts2) <-  make.names(log2.norm.counts1[,1],TRUE)

bwcolor = grDevices::colorRampPalette(c("yellow","grey", "blue"))
pheatmap(
      log2.norm.counts2,
      filename   = "DESEQ2/Heatmap.pdf",
      clustering_dist_rows = "correlation",
      scale      = 'row',
      cellheight = 8,
      cellwidth =  8,
      fontsize   = 6,
      col        = bwcolor(50),
      treeheight_row = 0,
      treeheight_col = 0,
      cluster_cols = FALSE,
      border_color = NA)
}
