library("DESeq2")
library("ggplot2")
library("xlsx")
library("pheatmap")


setwd("~/Projects/23-1TOSH-001")
dir.create("DESEQ2", recursive=TRUE, showWarnings = FALSE) 

load("feature_count.RData")
feature_count1 <- as.data.frame(feature_count)
#your first columns which are gene id and gene name
feature_annotation <- cbind(GeneID=rownames(feature_count1),gene_name=feature_count1$gene_name)


DEG_analysis <- function(colnum,cond1, cond2, ref, rep_cond1,rep_cond2, group_name, sample_names)
{
 
  feature_count <- feature_count1[colnum]
  #at least one column has number
  feature_count <- feature_count[apply(feature_count,1,function(z) any(z!=0)),]
  
  sampleInfo=data.frame(sample_name=dput(as.character(names(feature_count))),
                        sample_type=dput(as.character(names(feature_count))),
                        sample_group=dput(as.character(c(rep(cond1,rep_cond1),rep(cond2,rep_cond2)))))

                        #sample_group=dput(as.character(c(rep(cond1,rep_cond1),rep(cond2,rep_cond2),rep(cond3,rep_cond3)))))
  
  
  group <- data.frame(sample_group=sampleInfo$sample_group)
  
  dds <- DESeqDataSetFromMatrix(countData=feature_count,colData=group,design=~sample_group)
  
  
  dds$sample_group <-relevel(dds$sample_group,ref=ref)
  
  ##########
  #PCA PLOT
  ##########
                         
  #gernate rlog for PCA
  rld <-rlog(dds,blind=FALSE)
  pdf(sprintf("DESEQ2/PCA_%s_%s_%s.pdf",cond2,cond1,group_name), width=8,height=8)
  nudge <- position_nudge(y = 0.5)
  p <- plotPCA(rld,intgroup=c("sample_group"))  
  p + geom_text(aes_string(label = "name"), color="black", position = nudge, size=2.8)
  dev.off()
  
  dds_wald <- DESeq(dds, betaPrior=FALSE, minReplicatesForReplace=Inf)
  res <- results(dds_wald, contrast=c("sample_group",cond2,cond1))
  
  resDF <- data.frame(GeneID=rownames(res),res)
  resDF <- merge(feature_annotation,resDF, by="GeneID")
  

  resDF1 <- subset(resDF, pvalue <= 0.05)
  #order on pvalue
  resDF1 <- resDF1[order(resDF1$pvalue),]

  log2FC1 <- resDF1$log2FoldChange
  resDF1$Fold_Change = ifelse(log2FC1 > 0, 2 ^ log2FC1, -1 / (2 ^ log2FC1))
                        
 write.xlsx(resDF1,file=sprintf("DESEQ2/DEG_%s_vs_%s_%s_filter_on_pval.xlsx",cond2,cond1,group_name), row.names = FALSE)
 # write.xlsx(resDF1,file=sprintf("DESEQ2/DEG_%s_vs_%s_%s_filter_on_padj.xlsx",cond2,cond1,group_name), row.names = FALSE)

#########
#HEATMAP 
#########                                      
select <- order(rowMeans(counts(dds_wald,normalized=TRUE)),decreasing=FALSE)[1:nrow(counts(dds_wald))]

nt <- normTransform(dds_wald)
log2.norm.counts <- assay(nt)[select,]
log2.norm.counts<- as.data.frame(log2.norm.counts)
                     
log2.norm.counts1 <- data.frame(GeneID=rownames(log2.norm.counts), log2.norm.counts)
colnames(log2.norm.counts1) <- c("GeneID",sample_names)
                                       
up <- resDF1[order(resDF1$Fold_Change,decreasing=TRUE),]
select_up_rows <- up[1:200,]
select_up_cols <- select_up_rows[,c(1,2)]

down <- resDF1[order(resDF1$Fold_Change,decreasing=FALSE),]
select_down_rows <- down[1:200,]
select_down_cols <- select_down_rows[,c(1,2)]
 
DF <- rbind(select_up_cols,select_down_cols)
DF <- DF[complete.cases(DF), ]

log2.norm.counts1 <- merge(DF,log2.norm.counts1, by=c("GeneID"))
log2.norm.counts2 <- log2.norm.counts1[,-1]

rownames(log2.norm.counts2) <-  make.names(log2.norm.counts2[,1],TRUE)
log2.norm.counts3 <- log2.norm.counts2[,-1]
#colnames(log2.norm.counts3) <- colname

bwcolor = grDevices::colorRampPalette(c("yellow","grey", "blue"))
pheatmap(
      log2.norm.counts3,
      filename   = sprintf("DESEQ2/Heatmap_%s_vs_%s_%s.pdf",cond2,cond1,group_name),
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

#CONTROL GROUP sample 33 is missing                       
DEG_analysis(c(3,6,8,9,11,12,16,26,29,31,32,34,35,39),"T0","T1","T0",7,7,"control",c("TO_19","TO_22","TO_24","TO_25","TO_27","TO_28","TO_33","T1_19","T1_22","T1_24","T1_25","T1_27","T1_28","T1_33")) 
DEG_analysis(c(3,9,11,16,26,32,34,39),"T0","T2","T0",4,4,"control",c("T0_19","T0_25","T0_27","T0_22","T1_19","T1_25","T1_27","T1_22"))
#sample 33 missing
DEG_analysis(c(6,8,12,29,31,35),"T0","T3","T0",3,3,"control",c("T0_22","T0_24","T0_28","T3_22","T3_24","T3_28"))

#BCG GROUP
DEG_analysis(c(4,5,13,14,15,19,20,22,27,28,36,37,38,42,43,45),"T0","T1","T0",8,8,"BCG",c("T0_20b","T0_21","T0_29","T0_30","T0_31","T0_36","T0_37","T0_39","T1_20b","T1_21","T1_29","T1_30","T1_31","T1_36","T1_37","T1_39"))
DEG_analysis(c(5,13,20,22,28,36,43,45),"T0","T2","T0",4,4,"BCG", c("T0_21","T0_29","T0_37","T0_39","T2_21","T2_29","T2_37","T2_39"))
DEG_analysis(c(4,14,15,19,27,37,38,42),"T0","T3","T0",4,4,"BCG",c("T0_20b","T0_30","T0_31","T0_36","T3_20b","T3_30","T3_31","T3_36"))        

#HIMB GROUP
DEG_analysis(c(7,10,17,18,21,23,24,25,30,33,40,41,44,46,47,48),"T0","T1","T0",8,8,"HIMB", c("T0_23","T0_26","T0_34","T0_35","T0_38","T0_40","T0_41","T0_42","T1_23","T1_26","T1_34","T1_35","T1_38","T1_40","T1_41","T1_42"))
DEG_analysis(c(18,23,24,25,55,58,59,60),"T0","T2","T0",4,4,"HIMB", c("T0_35","T0_40","T0_41","T0_42","T2_35","T2_40","T2_41","T2_42"))
DEG_analysis(c(7,10,17,21,63,65,69,71),"T0","T3","T0",4,4,"HIMB", c("T0_23","T0_26","T0_34","T0_38","T3_23","T3_26","T3_34","T3_38"))                       
                        
