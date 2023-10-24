library("DESeq2")
library("ggplot2")
library("xlsx")

setwd("~/Projects/23-1TOSH-001")
dir.create("DESEQ2", recursive=TRUE, showWarnings = FALSE) 

load("feature_count.RData")
feature_count1 <- as.data.frame(feature_count)

#your first columns which are gene id and gene name
feature_annotation <- cbind(GeneID=rownames(feature_count1),gene_name=feature_count1$gene_name)
DEG_analysis <-  function(colnum,cond1, cond2, ref, rep_cond1,rep_cond2, group_name)
{
 
  feature_count <- feature_count1[colnum]
  #at least one column has number
  feature_count <- feature_count[apply(feature_count,1,function(z) any(z!=0)),]
  
  sampleInfo=data.frame(sample_name=dput(as.character(names(feature_count))),
                        sample_type=dput(as.character(names(feature_count))),
                        #sample_group=dput(as.character(c(rep(cond1,rep_cond1),rep(cond2,rep_cond2),rep(cond3,rep_cond3)))))
  
                        #sample_group=dput(as.character(c(rep(cond1,rep_cond1),rep(cond2,rep_cond2)))))
  
  
  
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
  #pdf(sprintf("DESEQ2/PCA_%s_%s_%s.pdf",cond2,cond1,cond3), width=8,height=8)
  pdf(sprintf("DESEQ2/PCA_%s_%s_%s.pdf",cond2,cond1,group_name), width=8,height=8)
  nudge <- position_nudge(y = 0.5)
  p <- plotPCA(rld,intgroup=c("sample_group"))  
  p <- p + geom_text(aes_string(label = "name"), color="black", position = nudge, size=2.8)
  print(p)
  dev.off()
  
  dds_wald <- DESeq(dds, betaPrior=FALSE, minReplicatesForReplace=Inf)
  res <- results(dds_wald, contrast=c("sample_group",cond2,cond1))
  
  resDF <- data.frame(GeneID=rownames(res),res)
  resDF <- merge(feature_annotation,resDF, by="GeneID")
  
  #resDF1 <- subset(resDF, pvalue <= 0.05)
  #order on pvalue
  #resDF1 <- resDF1[order(resDF1$pvalue),]

  #order on fdr
  resDF1 <- resDF[order(resDF$padj),]
  resDF1 <- subset(resDF1, padj <= 0.05)

  log2FC1 <- resDF1$log2FoldChange
  resDF1$Fold_Change = ifelse(log2FC1 > 0, 2 ^ log2FC1, -1 / (2 ^ log2FC1))

  #return(dim(resDF1))
  #All significant
  #write.xlsx(resDF1,file=sprintf("DESEQ2/DEG_%s_vs_%s_filter_on_pval.xlsx",cond2,cond1), row.names = FALSE)
  write.xlsx(resDF1,file=sprintf("DESEQ2/DEG_%s_vs_%s_%s_filter_on_padj.xlsx",cond2,cond1,group_name), row.names = FALSE)
  
}
#T1 VS T2
#DEG_analysis(c(3:48),"T1","T2","T1",23,23)
#T1 VS T3
#DEG_analysis(c(3:25,49:71),"T1","T3","T1",23,23)
#T1 VS T3
#DEG_analysis(c(3:71),"T1","T2","T3","T1",23,23,23)
#T0 VS T1
[1] "GeneID"    "gene_name" "R2300053"  "R2300054"  "R2300055"  "R2300056" 
[7] "R2300057"  "R2300058"  "R2300059"  "R2300060"  "R2300061"  "R2300062" 
[13] "R2300063"  "R2300064"  "R2300065"  "R2300066"  "R2300067"  "R2300068" 
[19] "R2300069"  "R2300070"  "R2300071"  "R2300072"  "R2300073"  "R2300074" 
[25] "R2300075"  "R2300076"  "R2300077"  "R2300078"  "R2300079"  "R2300080" 
[31] "R2300081"  "R2300082"  "R2300083"  "R2300084"  "R2300085"  "R2300086" 
[37] "R2300087"  "R2300088"  "R2300089"  "R2300090"  "R2300091"  "R2300092" 
[43] "R2300093"  "R2300094"  "R2300095"  "R2300096"  "R2300097"  "R2300098" 
[49] "R2300099"  "R2300100"  "R2300101"  "R2300102"  "R2300103"  "R2300104" 
[55] "R2300105"  "R2300106"  "R2300107"  "R2300108"  "R2300109"  "R2300110" 
[61] "R2300111"  "R2300112"  "R2300113"  "R2300114"  "R2300115"  "R2300116" 
[67] "R2300117"  "R2300118"  "R2300119"  "R2300120"  "R2300121" 

#CONTROL GROUP sample 33 is missing                       
DEG_analysis(c(3,6,8,9,11,12,16,?,26,29,31,32,34,35,39,?),"T0","T1","T0",8,8,"control")
DEG_analysis(c(3,9,11,16,26,32,34,39),"T0","T2","T0",4,4,"control")
#sample 33 missing
DEG_analysis(c(6,8,12,?,29,31,35,?),"T0","T3","T0",4,4,"control")

#BCG GROUP
DEG_analysis(c(4,5,13,14,15,19,20,22,27,28,36,37,38,42,43,45),"T0","T1","T0",8,8,"BCG")
DEG_analysis(c(5,13,),"T0","T2","T0",4,4,"BCG")
DEG_analysis(c(3:48),"T0","T3","T0",4,4,"BCG")        

#HIMB GROUP
DEG_analysis(c(3:48),"T0","T1","T0",8,8,"HIMB")
DEG_analysis(c(3:48),"T0","T2","T0",4,4,"HIMB")
DEG_analysis(c(3:48),"T0","T3","T0",4,4,"HIMB")                       
                        
