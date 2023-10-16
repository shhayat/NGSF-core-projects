#setwd("/Users/shahina/Projects/23-1LICH-001")
setwd("/Users/hxo752/Desktop/core-projects/23-1LICH-001/")
library("DESeq2")
library("ggplot2")
#library("xlsx")
library("sva")


dir.create("DESEQ2", recursive=TRUE, showWarnings = FALSE) 

load("feature_count.RData")
feature_count <- as.data.frame(feature_count)
names(feature_count) <- c("GeneID","Gene","A3A_U6_R1","A3A_I5_R1","A3B_U2_R1","A3B_I5_R1","A3H_U1_R1","A3H_I4_R1","A3A_U6_R2","A3A_I5_R2","A3B_U2_R2","A3B_I5_R2","A3H_U1_R2",
                          "A3A_U1_R1","A3A_I4_R1","A3A_U1_R2","A3A_I4_R2","A3B_U1_R1",
                          "A3B_I2_R1","A3B_I2_R2","A3H_U2_R1","A3H_I1_R1","A3H_U2_R2","A3H_I1_R2","A3H_I4_R2","A3B_U1_R2")
#remove number after decimal point from ensembl ID
geneID <- gsub(".[0-9]*$", "", rownames(feature_count))
rownames(feature_count) <- geneID

#your first columns which are gene id and gene name
feature_annotation <- data.frame(GeneID=geneID,gene_name=feature_count[2])


DEG_analysis_batch_corrected <-  function(colnum,cond1, cond2, ref, rep_cond1,rep_cond2, batch)
{
  feature_count <- feature_count[colnum]
  #remove row with sum zero
  feature_count <- feature_count[rowSums(feature_count[,c(1:ncol(feature_count))])> 1, ]
  
  sampleInfo=data.frame(sample_name=dput(as.character(names(feature_count))),
                        sample_type=dput(as.character(names(feature_count))),
                        sample_group=dput(as.character(c(rep(cond1,rep_cond1),rep(cond2,rep_cond2)))),
                         batch_number=batch)

group <- data.frame(sample_group=sampleInfo$sample_group,batch_number=sampleInfo$batch_number)


############################################
#COMBAT_SEQ (batch adjusted and plotted pca)
############################################
pdf(sprintf("PCA_%s_%s_batch_adjusted_combatseq.pdf",cond2,cond1), width=8,height=8)

adjusted_counts <- ComBat_seq(feature_count, batch=sampleInfo$batch_number, group=sampleInfo$sample_group)
#pc_data <- prcomp(combat_data)
pca_result <- prcomp(t(adjusted_counts), scale. = FALSE)
pc_data <- as.data.frame(pca_result$x)

pc_standard_deviations <- pca_result$sdev
pc_variances <- round(100 * (pc_standard_deviations^2 / sum(pc_standard_deviations^2)))

# Add batch information, sample_group, sample_name to the PCA results for visualization
pc_data$Batch <- sampleInfo$batch_number
pc_data$sample_group <- sampleInfo$sample_group
pc_data$sample_name <- sampleInfo$sample_name
nudge=position_nudge(y = 0.5)
p <- ggplot(pc_data, aes(x = PC1 , y = PC2, color = sample_group, shape = Batch)) +
  geom_point(size = 3) +
  ggtitle("PCA with ComBat_seq Adjusted Counts") +
  xlab(paste0("PC1: ",pc_variances[1],"% variance")) +
  ylab(paste0("PC2: ",pc_variances[2],"% variance")) +
  scale_color_discrete(name = "TimePoint") +
  scale_shape_discrete(name = "Batch") +
  theme_minimal() + 
  geom_text(aes_string(label = "sample_name"), color="black",  position=nudge , size=2.0)
  print(p)
dev.off()

  dds <- DESeqDataSetFromMatrix(countData=adjusted_counts,
                                colData=group,
                                design=~sample_group)
  
  dds$sample_group <-relevel(dds$sample_group,ref=ref)
  
  dds_wald <- DESeq(dds, betaPrior=FALSE, minReplicatesForReplace=Inf)
  res <- results(dds_wald, contrast=c("sample_group",cond2,cond1))
  
   resDF <- data.frame(GeneID=rownames(res),res)
   resDF <- merge(feature_annotation,resDF, by="GeneID")
   resDF <- resDF[resDF$pvalue <= 0.05,]
   resDF <- resDF[order(resDF$pvalue),]
   resDF$Fold_Change = ifelse(resDF$log2FoldChange > 0, 2 ^ resDF$log2FoldChange, -1 / (2 ^ resDF$log2FoldChange))
   write.xlsx(resDF,file=sprintf("DESEQ2/DEG_%s_vs_%s_batch_adjusted_combatseq.xlsx",cond2,cond1), row.names = FALSE)
}


#with batch correction
DEG_analysis_batch_corrected(c(3,9,4,10),"A3A_U6","A3A_I5","A3A_U6",2,2, c("B1","B2","B1","B2"))
DEG_analysis_batch_corrected(c(5,11,12,6),"A3B_U2","A3B_I5","A3B_U2",2,2, c("B1","B2","B2","B1"))
DEG_analysis_batch_corrected(c(7,13,8,25),"A3H_U1","A3H_I4","A3H_U1",2,2, c("B1","B2","B1","B2"))





load("feature_count.RData")
feature_count <- as.data.frame(feature_count)
names(feature_count) <- c("GeneID","Gene","A3A_U6_R1","A3A_I5_R1","A3B_U2_R1","A3B_I5_R1","A3H_U1_R1","A3H_I4_R1","A3A_U6_R2","A3A_I5_R2","A3B_U2_R2","A3B_I5_R2","A3H_U1_R2",
                          "A3A_U1_R1","A3A_I4_R1","A3A_U1_R2","A3A_I4_R2","A3B_U1_R1",
                          "A3B_I2_R1","A3B_I2_R2","A3H_U2_R1","A3H_I1_R1","A3H_U2_R2","A3H_I1_R2","A3H_I4_R2","A3B_U1_R2")
#remove number after decimal point from ensembl ID
geneID <- gsub(".[0-9]*$", "", rownames(feature_count))
rownames(feature_count) <- geneID

#your first columns which are gene id and gene name
feature_annotation <- data.frame(GeneID=geneID,gene_name=feature_count[2])





DEG_analysis <-  function(colnum,cond1, cond2, ref, rep_cond1,rep_cond2)
{
  feature_count <- feature_count[colnum]
  #remove row with sum zero
  feature_count <- feature_count[rowSums(feature_count[,c(1:ncol(feature_count))])> 1, ]
  
  sampleInfo=data.frame(sample_name=dput(as.character(names(feature_count))),
                        sample_type=dput(as.character(names(feature_count))),
                        sample_group=dput(as.character(c(rep(cond1,rep_cond1),rep(cond2,rep_cond2)))))

group <- data.frame(sample_group=sampleInfo$sample_group)

dds <- DESeqDataSetFromMatrix(countData=feature_count,
                                colData=group,
                                design=~sample_group)
  
  dds$sample_group <-relevel(dds$sample_group,ref=ref)
  dds_wald <- DESeq(dds, betaPrior=FALSE, minReplicatesForReplace=Inf)
  res <- results(dds_wald, contrast=c("sample_group",cond2,cond1))
  
   resDF <- data.frame(GeneID=rownames(res),res)
   resDF <- merge(feature_annotation,resDF, by="GeneID")
   resDF <- resDF[resDF$pvalue <= 0.05,]
   resDF <- resDF[order(resDF$pvalue),]
   resDF$Fold_Change = ifelse(resDF$log2FoldChange > 0, 2 ^ resDF$log2FoldChange, -1 / (2 ^ resDF$log2FoldChange))
  # write.xlsx(resDF,file=sprintf("DESEQ2/DEG_%s_vs_%s.xlsx",cond2,cond1), row.names = FALSE)
  
  ##########
  #PCA PLOT
  ##########
  #gernate rlog for PCA
  rld <-rlog(dds,blind=FALSE)
  pdf(sprintf("PCA_%s_%s.pdf",cond2,cond1), width=8,height=8)
   nudge <- position_nudge(y = 0.5)
   p <- plotPCA(rld,intgroup=c("sample_group"))  
   p <- p + geom_text(aes_string(label = "name"), color="black", position = nudge, size=2.8)
   print(p)
  dev.off()
}
#A3A_I5 vs A3A_U6 (n=2)
DEG_analysis(c(3,9,4,10),"A3A_U6","A3A_I5","A3A_U6",2,2)
#A3B_I5 vs A3B_U2 (n=2)
DEG_analysis(c(5,11,12,6),"A3B_U2","A3B_I5","A3B_U2",2,2)
#A3H_I4 vs A3H_U1 (n=2)
DEG_analysis(c(7,13,8,25),"A3H_U1","A3H_I4","A3H_U1",2,2)

