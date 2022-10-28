library("DESeq2")
library("ggplot2")
library("dplyr")
library("ggrepel")


setwd("/Users/shahina/Projects/22-1BETO-001")
dir.create("DESEQ2", recursive=TRUE, showWarnings = FALSE) 

load("feature_count.RData")
feature_count1 <- as.data.frame(feature_count)
#geneID <- gsub(".[0-9]*$", "", rownames(feature_count))
#rownames(feature_count) <- geneID

#your first columns which are gene id and gene name
feature_annotation <- feature_count1[1:2]

DEG_analysis <-  function(colnum,cond1, cond2, ref)
{
#feature_count <- feature_count[colnum]
  feature_count <- feature_count[c(3,5,7,4,6,8)]
  #at least one column has number
  feature_count <- feature_count[apply(feature_count,1,function(z) any(z!=0)),]
  
  sampleInfo=data.frame(sample_name=dput(as.character(names(feature_count))),
                        sample_type=dput(as.character(names(feature_count))),
                        sample_group=dput(as.character(c(rep(cond1,3),rep(cond2,3)))))
  
  
  
  group <- data.frame(sample_group=sampleInfo$sample_group)
  
  dds <- DESeqDataSetFromMatrix(countData=feature_count,
                                colData=group,
                                design=~sample_group)
  
  
  dds$sample_group <-relevel(dds$sample_group,ref="untreated")
  
  ##########
  #PCA PLOT
  ##########
  pdf(sprintf("PCA_%s_%s.csv",cond2,cond1))
  #gernate rlog for PCA
  rld <-rlog(dds,blind=FALSE)
  pdf(sprintf("PCA_%s_%s.pdf",cond2,cond1), width=15,height=15)
  nudge <- position_nudge(y = 0.5)
  p <- plotPCA(rld,intgroup=c("sample_group"))  
  p <- p + geom_text(aes_string(label = "name"), color="black", position = nudge, size=2.8)
  print(p)
  dev.off()
  

  dds_wald <- DESeq(dds, betaPrior=FALSE, minReplicatesForReplace=Inf)
  
  #summary(res)
  resDF <- data.frame(GeneID=rownames(res_D4_vs_D1),res_D4_vs_D1)
  resDF <- merge(feature_annotation,resDF, by="GeneID")
  #remove rows with all NAs
  resDF1 <- resDF[rowSums(is.na(resDF)) != ncol(resDF), ]
  resDF1<- filter(resDF1, pvalue <= 0.05)
  #order on FDR
  resDF1 <- resDF1[order(resDF1$padj),]
  log2FC1 <- resDF1$log2FoldChange
  resDF1$Fold_Change = ifelse(log2FC1 > 0, 2 ^ log2FC1, -1 / (2 ^ log2FC1))
#filter(resDF11, padj <= 0.01)
 
#All significant
write.csv(resDF1,file=sprintf("DEG_%s_vs_%s_filter_on_pval.csv",cond2,cond1),quote=FALSE, row.names = FALSE)

}
DEG_analysis(c(1:6),"ABN","AB4","ABN")
DEG_analysis(c(7:12),"DN","D4","DN")
                   
