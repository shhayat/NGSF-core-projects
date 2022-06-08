
library("DESeq2")
library("AnnotationDbi")
library("org.Hs.eg.db")
library("ggplot2")
library("biomaRt")

setwd("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1LICH-001/")
dir.create("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1LICH-001//DESEQ2", recursive=TRUE, showWarnings = FALSE) 

load("feature_count.RData")
feature_count <- as.data.frame(feature_count)
geneID <- gsub(".[0-9]*$", "", rownames(feature_count))
rownames(feature_count) <- geneID

names(feature_count) = gsub(pattern = "_S[0-9].*", replacement = "", x = names(feature_count))

DEG_analysis <-  function(colnum,cond1, cond2, ref)
{
feature_count <- feature_count[colnum]

feature_count <- feature_count[c(1,3,5,2,4,6)]
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
res$symbol <- mapIds(org.Hs.eg.db,
                     keys=row.names(res),
                     column="SYMBOL",
                     keytype="ENSEMBL",
                     multiVals="first")
                     
ensembl = biomaRt::useMart("ensembl", dataset='hsapiens_gene_ensembl')
attributes = biomaRt::listAttributes(ensembl)
select_attributes = biomaRt::getBM(attributes = c('ensembl_gene_id','gene_biotype'), mart = ensembl)
names(select_attributes) <- c("gene_id","gene_biotype")  


res_pval <- subset(res, pvalue <= 0.05)
res_pval_ordered <- res_pval[order(res_pval$pvalue),]
resDF <- data.frame(gene_id=rownames(res_pval_ordered),res_pval_ordered)
resDF1 <- merge(resDF, select_attributes, by="gene_id")

#All significant
write.csv(resDF1,file=sprintf("DESEQ2/DESEQ2_DEG_%s_vs_%s_filter_on_pval.csv",cond2,cond1),quote=FALSE, row.names = FALSE)


##########
#PCA PLOT
##########
#gernate rlog for PCA
  rld <-rlog(dds,blind=FALSE)
  pdf(sprintf("DESEQ2/PCA_%s_%s.pdf",cond1,cond2))
    nudge <- position_nudge(y = 1)
    p <- plotPCA(rld,intgroup=c("sample_group"))  
    p <- p + geom_text(aes_string(label = "name"), color="black", position = nudge)
    print(p)
dev.off()


#########
#MA PLOT
#########
pdf(sprintf("DESEQ2/MA_plot_%s_vs_%s.pdf",cond2,cond1))
   ylim <- c(-3,3)
   resGA <- results(dds_wald, lfcThreshold=.5, altHypothesis="greaterAbs")
   drawLines <- function() abline(h=c(-.5,.5),col="dodgerblue",lwd=2)
   plotMA(resGA, ylim=ylim); drawLines()
dev.off()


}
Untreated_vs_Treated   <- DEG_analysis(c(1:6),"Untreated","Treated","Untreated")
