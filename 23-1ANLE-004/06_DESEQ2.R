setwd("/Users/shahina/Projects/23-1ANLE-004")
#setwd("/Users/hxo752/Desktop/core-projects/23-1ANLE-004")

library("DESeq2")
library("ggplot2")
library("xlsx")

dir.create("DESEQ2", recursive=TRUE, showWarnings = FALSE) 

load("feature_count.RData")
feature_count <- as.data.frame(feature_count)

#remove number after decimal point from ensembl ID
geneID <- gsub(".[0-9]*$", "", rownames(feature_count))
rownames(feature_count) <- geneID

#your first columns which are gene id and gene name
feature_annotation <- data.frame(GeneID=geneID,gene_name=feature_count[2])


DEG_analysis <-  function(colnum,cond1, cond2, ref, rep_cond1,rep_cond2)
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
 # rld <-rlog(dds,blind=FALSE)
 # pdf(sprintf("PCA_%s_%s.pdf",cond2,cond1), width=8,height=8)
 # nudge <- position_nudge(y = 0.5)
 # p <- plotPCA(rld,intgroup=c("sample_group"))  
 # p <- p + geom_text(aes_string(label = "name"), color="black", position = nudge, size=2.8)
  #print(p)
  #dev.off()
  
  dds_wald <- DESeq(dds, betaPrior=FALSE, minReplicatesForReplace=Inf)
  res <- results(dds_wald, contrast=c("sample_group",cond2,cond1))
  
  resDF <- data.frame(GeneID=rownames(res),res)
  resDF <- merge(feature_annotation,resDF, by="GeneID")
  resDF <- resDF[order(resDF$pvalue),]
  log2FC <- resDF$log2FoldChange
  resDF$Fold_Change = ifelse(log2FC > 0, 2 ^ log2FC, -1 / (2 ^ log2FC))
  increased_DF=resDF[resDF$Fold_Change >= 1.5,]
  decreased_DF=resDF[resDF$Fold_Change <= -1.5,]

  #resDF1 <- resDF[resDF$pvalue <= 0.05,]
  #All Genes
  #write.xlsx(resDF,file=sprintf("DESEQ2/DEG_%s_vs_%s_all_genes.xlsx",cond2,cond1), row.names = FALSE)
  #write.xlsx(resDF1,file=sprintf("DESEQ2/DEG_%s_vs_%s.xlsx",cond2,cond1), row.names = FALSE)
  write.xlsx(increased_DF,file=sprintf("DESEQ2/DEG_%s_vs_%s_increased.xlsx",cond2,cond1), row.names = FALSE)
  write.xlsx(decreased_DF,file=sprintf("DESEQ2/DEG_%s_vs_%s_decreased.xlsx",cond2,cond1), row.names = FALSE)
}
DEG_analysis(c(3,5,7,4,6,8),"CONTROL","DMOG","CONTROL",3,3)

