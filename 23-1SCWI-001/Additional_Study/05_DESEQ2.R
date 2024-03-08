setwd("/Users/shahina/Projects/2023_projects/23-1SCWI-001/Additional_Analysis/")

library("DESeq2")
library("ggplot2")
library("xlsx")

dir.create("DESEQ2", recursive=TRUE, showWarnings = FALSE) 

load("feature_count.RData")
feature_count <- as.data.frame(feature_count)
colnames(feature_count) <- c("geneID","gene_name","RT_0_1", "RT_0_2", "RT_0_3","RT_0_4","RT_4_1","RT_4_2",
                                                         "RT_4_3","RT_4_4","RT_12_1","RT_12_2","RT_12_3","RT_12_4","RT_12_5","RT_24_1",
                                                         "RT_24_2","RT_24_3","RT_24_4","RT_24_5")
#remove number after decimal point from ensembl ID
geneID <- gsub(".[0-9]*$", "", rownames(feature_count))
rownames(feature_count) <- geneID

#your first columns which are gene id and gene name
feature_annotation <- data.frame(GeneID=geneID,gene_name=feature_count[2])

DEG_analysis <-  function(colnum,cond1, cond2, ref,rep_cond1,rep_cond2)
{
  feature_count <- feature_count[colnum]
  #keep row with sum greater than 1
  feature_count <- feature_count[rowSums(feature_count[,c(1:ncol(feature_count))])>3, ]
  
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
  pdf(sprintf("PCA_%s_vs_%s.pdf",cond2,cond1), width=8,height=8)
   nudge <- position_nudge(y = 0.8)
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

 # resDF <- resDF[resDF$pvalue <= 0.05,]
  #All Genes
  write.xlsx(resDF,file=sprintf("DESEQ2/DEG_%s_vs_%s.xlsx",cond2,cond1), row.names = FALSE)

}
DEG_analysis(c(3:6,7:10),"0hrs","4hrs","0hrs",4,4)
DEG_analysis(c(3:6,11:15),"0hrs","12hrs","0hrs",4,5)
DEG_analysis(c(3:6,16:20),"0hrs","24hrs","0hrs",4,5)
