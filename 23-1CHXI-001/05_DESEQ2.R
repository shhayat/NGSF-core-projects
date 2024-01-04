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
  rld <-rlog(dds,blind=FALSE)
  pdf(sprintf("PCA_%s_%s_%s.pdf",cond2,cond1,str), width=8,height=8)
    nudge <- position_nudge(y = 0.5)
    p <- plotPCA(rld,intgroup=c("sample_group"))  
    p <- p + geom_text(aes_string(label = "name"), color="black", position = nudge, size=2.8)
    print(p)
  dev.off()
  
  dds_wald <- DESeq(dds, betaPrior=FALSE, minReplicatesForReplace=Inf)
  res <- results(dds_wald, contrast=c("sample_group",cond2,cond1))
  
  resDF <- data.frame(GeneID=rownames(res),res)
  resDF <- merge(feature_annotation,resDF, by="GeneID")
  resDF <- resDF[order(resDF$pvalue),]
  log2FC <- resDF$log2FoldChange
  resDF$Fold_Change = ifelse(log2FC > 0, 2 ^ log2FC, -1 / (2 ^ log2FC))

  resDF1 <- resDF[resDF$pvalue <= 0.05,]
  
  write.xlsx(resDF1,file=sprintf("DESEQ2/DEG_%s_vs_%s_%s.xlsx",cond2,cond1, str), row.names = FALSE)
}
DEG_analysis(c(9,10,11,12,13,14,3,4,5,6,7,8),"CONTROL","HFD","CONTROL",6,6, "all_sample")
DEG_analysis(c(10,11,13,14,4,5,6,7,8),"CONTROL","HFD","CONTROL",4,5,"filtered_sample")
