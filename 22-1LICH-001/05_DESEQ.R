
library("DESeq2")
#library("ggplot2")

dir.create("/Users/hxo752/Desktop/22-1LICH-001/DESEQ2", recursive=TRUE, showWarnings = FALSE) 
setwd("/Users/hxo752/Desktop/22-1LICH-001")

load("feature_count.RData")
feature_count <- as.data.frame(feature_count)
geneID <- gsub(".[0-9]*$", "", rownames(feature_count))
rownames(feature_count) <- geneID

feature_annotation <- feature_count[1:2]
feature_annotation$GeneID <- gsub(".[0-9]*$", "",feature_annotation$GeneID)

DEG_analysis <-  function(colnum,cond1, cond2, ref)
{
#feature_count <- feature_count[colnum]
  feature_count <- feature_count[c(3,5,7,4,6,8)]
  #at least one column has number
  feature_count <- feature_count[apply(feature_count,1,function(z) any(z!=0)),]
  
  sampleInfo=data.frame(sample_name=dput(as.character(names(feature_count))),
                        sample_type=dput(as.character(names(feature_count))),
                        sample_group=dput(as.character(c(rep("untreated",3),rep("treated",3)))))
  
  
  
  group <- data.frame(sample_group=sampleInfo$sample_group)
  
  dds <- DESeqDataSetFromMatrix(countData=feature_count,
                                colData=group,
                                design=~sample_group)
  
  
  dds$sample_group <-relevel(dds$sample_group,ref="untreated")
  
  ##########
  #PCA PLOT
  ##########
  #gernate rlog for PCA
  rld <-rlog(dds,blind=FALSE)
  pdf(sprintf("PCA_%s_%s.pdf",cond2,cond1), width=15,height=15)
  nudge <- position_nudge(y = 0.5)
  p <- plotPCA(rld,intgroup=c("sample_group"))  
  p <- p + geom_text(aes_string(label = "name"), color="black", position = nudge, size=2.8)
  print(p)
  dev.off()
                                       
  
  dds_wald <- DESeq(dds, betaPrior=FALSE, minReplicatesForReplace=Inf)
  
  #results with independent filtering and outlier removal and padj is by default 0.1
  res_unshrunken <- results(dds_wald, independentFiltering=TRUE,cooksCutoff=TRUE)
  resLFC_shrunken <- lfcShrink(dds_wald, coef=2, type="normal")
  
 # plotMA(res_unshrunken, ylim=c(-2,2))
 # plotMA(resLFC_shrunken, ylim=c(-2,2))
                                       
  #summary(res)
  resDF <- data.frame(GeneID=rownames(resLFC_shrunken),resLFC_shrunken)
  resDF1 <- merge(feature_annotation,resDF, by="GeneID")
  res_pval <- subset(resDF1, pvalue <= 0.05)
  res_pval_ordered <- res_pval[order(res_pval$pvalue),]
  

#All significant
write.csv(resDF1,file=sprintf("DESEQ2/DESEQ2_DEG_%s_vs_%s_filter_on_pval.csv",cond2,cond1),quote=FALSE, row.names = FALSE)


}
Untreated_vs_Treated   <- DEG_analysis(c(1:6),"Untreated","Treated","Untreated")
                                     
     
