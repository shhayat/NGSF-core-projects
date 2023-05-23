library("DESeq2")
library("ggplot2")
library("xlsx")

setwd("~/Projects/23-1JOHO-001")
dir.create("DESEQ2", recursive=TRUE, showWarnings = FALSE) 

load("feature_count.RData")
feature_count1 <- as.data.frame(feature_count)

geneID <- gsub(".[0-9]*$", "", rownames(feature_count1))
rownames(feature_count1) <- geneID

#your first columns which are gene id and gene name
feature_annotation <- cbind(GeneID=rownames(feature_count1),gene_name=feature_count1$gene_name)
DEG_analysis <-  function(colnum,cond1, cond2, ref, rep_cond1,rep_cond2)
{
  #feature_count <- feature_count[colnum]
  feature_count <- feature_count1[colnum]
  #at least one column has number
  #feature_count <- feature_count[apply(feature_count,1,function(z) any(z!=0)),]
  
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
  pdf(sprintf("DESEQ2/PCA_%s_%s.pdf",cond2,cond1), width=8,height=8)
  nudge <- position_nudge(y = 0.5)
  p <- plotPCA(rld,intgroup=c("sample_group"))  
  p <- p + geom_text(aes_string(label = "name"), color="black", position = nudge, size=2.8)
  print(p)
  dev.off()
  
  dds_wald <- DESeq(dds, betaPrior=FALSE, minReplicatesForReplace=Inf)
  res <- results(dds_wald, contrast=c("sample_group",cond2,cond1))
  
  resDF <- data.frame(GeneID=rownames(res),res)
  resDF <- merge(feature_annotation,resDF, by="GeneID")
  
  resDF1 <- subset(resDF, pvalue <= 0.05)
  #order on FDR
  resDF1 <- resDF1[order(resDF1$pvalue),]
  log2FC1 <- resDF1$log2FoldChange
  resDF1$Fold_Change = ifelse(log2FC1 > 0, 2 ^ log2FC1, -1 / (2 ^ log2FC1))

  #return(dim(resDF1))
  #All significant
  write.xlsx(resDF1,file=sprintf("DESEQ2/DEG_%s_vs_%s_filter_on_pval.xlsx",cond2,cond1), row.names = FALSE)
  
}
#T1 VS T2
DEG_analysis(c(3:5,16,7:9,18,6,10,12,14,15,17),"T1","T2","T1",8,6)

#T1 VS T3
DEG_analysis(c(3:5,16,7:9,6,17),"T1","T3","T1",7,2)

#T1 VS T3
DEG_analysis(c(3:5,16,7:9,6,17),"T1","T3","T1",7,2)


