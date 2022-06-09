
library("DESeq2")
library("AnnotationDbi")
library("org.Hs.eg.db")
library("ggplot2")
library("biomaRt")

dir.create("/Users/hxo752/Desktop/22-1LICH-001/DESEQ2", recursive=TRUE, showWarnings = FALSE) 
setwd("/Users/hxo752/Desktop/22-1LICH-001")

load("feature_count.RData")
feature_count <- as.data.frame(feature_count)
geneID <- gsub(".[0-9]*$", "", rownames(feature_count))
rownames(feature_count) <- geneID

feature_annotation <- feature_count[1:3]

DEG_analysis <-  function(colnum,cond1, cond2, ref)
{
#feature_count <- feature_count[colnum]

feature_count <- feature_count[c(4,6,8,5,7,9)]
#at least one column has number
feature_count <- feature_count[apply(feature_count,1,function(z) any(z!=0)),]

sampleInfo=data.frame(sample_name=dput(as.character(names(feature_count))),
                      sample_type=dput(as.character(names(feature_count))),
                      sample_group=dput(as.character(c(rep(cond1,3),rep(cond2,3)))))



group <- data.frame(sample_group=sampleInfo$sample_group)

dds <- DESeqDataSetFromMatrix(countData=feature_count,
                              colData=group,
                              design=~sample_group)

dds$sample_group <-relevel(dds$sample_group,ref=ref)
dds <- estimateSizeFactors(dds)
dds <- estimateDispersionsGeneEst(dds)
dispersions(dds) <- mcols(dds)$dispGeneEst
dds_wald <- DESeq(dds, betaPrior=TRUE, minReplicatesForReplace=Inf)

#results with independent filtering and outlier removal and padj is by default 0.1
res <- results(dds_wald, independentFiltering=TRUE,cooksCutoff=TRUE)
#summary(res)
resDF <- data.frame(GeneID=rownames(res),res)
resDF1 <- merge(feature_annotation,resDF, by="GeneID")
res_pval <- subset(resDF1, pvalue <= 0.05)
res_pval_ordered <- res_pval[order(res_pval$pvalue),]

#All significant
write.csv(resDF1,file=sprintf("DESEQ2/DESEQ2_DEG_%s_vs_%s_filter_on_pval.csv",cond2,cond1),quote=FALSE, row.names = FALSE)

##########
#PCA PLOT
##########
  #gernate rlog for PCA
  rld <-rlog(dds,blind=FALSE)
  pdf(sprintf("DESEQ2/PCA_%s_%s.pdf",cond2,cond1), width=15,height=15)
  nudge <- position_nudge(y = 0.5)
  p <- plotPCA(rld,intgroup=c("sample_group"))  
  p <- p + geom_text(aes_string(label = "name"), color="black", position = nudge, size=2.8)
  print(p)
  dev.off()

}
Untreated_vs_Treated   <- DEG_analysis(c(1:6),"Untreated","Treated","Untreated")
