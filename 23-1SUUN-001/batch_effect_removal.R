library("DESeq2")
library("xlsx")
library("ggplot2")
library("sva")

setwd("/Users/shahina/Projects/23-1SUUN-001/")
dir.create("DESEQ2", recursive=TRUE, showWarnings = FALSE) 

load("feature_count.RData")
feature_count1 <- as.data.frame(feature_count)

feature_count <- feature_count1[3:14]
feature_count2 <- feature_count[rowSums(feature_count2[])>0,]
sampleInfo=data.frame(sample_name=dput(as.character(names(feature_count))),
                      sample_type=dput(as.character(names(feature_count))),
                      sample_group=dput(as.character(c(rep("T0",6),rep("T100",6)))),
                      batch_number=c("B2","B1","B1","B2","B2","B1","B1","B1","B1","B2","B1","B2"))

group <- data.frame(sample_group=sampleInfo$sample_group,batch_number=sampleInfo$batch_number )

#########################
#PCA BEFORE BATCH REMOVAL
#########################
dds <- DESeqDataSetFromMatrix(countData=feature_count2,
                              colData=group,
                              design=~sample_group)
vsd <- vst(dds)
nudge <- position_nudge(y = 0.5)
pdf("PCA_before_batch_correction.pdf")
p <- plotPCA(vsd,intgroup=c("sample_group"))
p + geom_text(aes_string(label = "name"), color="black", position = nudge, size=3.0)
dev.off()

#######################################################
#PCA AFTER BATCH REMOVAL USING limma::removeBatchEffect
#######################################################
pdf("PCA_batch_correction_limma.pdf")
dds <- DESeqDataSetFromMatrix(countData=feature_count2,
                              colData=group,
                              design=~batch_number+sample_group)
vsd <- vst(dds)
assay(vsd) <- limma::removeBatchEffect(assay(vsd), vsd$batch_number)
nudge <- position_nudge(y = 0.8)
pcaData <- plotPCA(vsd, intgroup=c("batch_number", "sample_group"), returnData=TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))
ggplot(pcaData, aes(PC1, PC2, color=sample_group, shape = batch_number)) +
  geom_point(size=3) +
  xlab(paste0("PC1: ",percentVar[1],"% variance")) +
  ylab(paste0("PC2: ",percentVar[2],"% variance")) +
  geom_text(aes(label=sampleInfo$sample_name),color="black", position = nudge, size=2.0)
dev.off()


############################################
#COMBAT_SEQ (batch adjusted and plotted pca)
############################################

pdf("PCA_batch_adjusted_combatseq.pdf")
adjusted_counts <- ComBat_seq(feature_count2, batch=sampleInfo$batch_number, group=sampleInfo$sample_group)
#pc_data <- prcomp(combat_data)
pca_result <- prcomp(t(adjusted_counts), scale. = TRUE)
pc_data <- as.data.frame(pca_result$x)

#pc_standard_deviations <- pca_result$sdev
pc_variances <- round(100 * (pc_standard_deviations^2 / sum(pc_standard_deviations^2)))

# Add batch information, sample_group, sample_name to the PCA results for visualization
pc_data$Batch <- sampleInfo$batch_number
pc_data$sample_group <- sampleInfo$sample_group
pc_data$sample_name <- sampleInfo$sample_name
nudge=position_nudge(y = 0.5)
ggplot(pc_data, aes(x = PC1 , y = PC2, color = sample_group, shape = Batch)) +
  geom_point(size = 3) +
  ggtitle("PCA with ComBat_seq Adjusted Counts") +
  xlab(paste0("PC1: ",pc_variances[1],"% variance")) +
  ylab(paste0("PC2: ",pc_variances[2],"% variance")) +
  scale_color_discrete(name = "TimePoint") +
  scale_shape_discrete(name = "Batch") +
  theme_minimal() + 
  geom_text(aes_string(label = "sample_name"), color="black",  position=nudge , size=2.0)
dev.off()

#DESEQ2 analysis with adjusted_counts 
#according to this paper combat_seq adjusted count can be pass down to edgeR or DESEQ2
#https://academic.oup.com/nargab/article/2/3/lqaa078/5909519
#https://support.bioconductor.org/p/9138767/
dds <- DESeqDataSetFromMatrix(countData=adjusted_counts,
                              colData=group,
                              design=~sample_group)

dds$sample_group <-relevel(dds$sample_group,ref="T0")
dds_wald <- DESeq(dds, betaPrior=FALSE, minReplicatesForReplace=Inf)
res <- results(dds_wald, contrast=c("sample_group","T100","T0"))

feature_annotation <- cbind(GeneID=rownames(feature_count1),gene_name=feature_count1$gene_name)
resDF <- data.frame(GeneID=rownames(res),res)
resDF <- merge(feature_annotation,resDF, by="GeneID")

resDF1 <- subset(resDF, pvalue <= 0.05)
#order on FDR
resDF1 <- resDF1[order(resDF1$pvalue),]
log2FC1 <- resDF1$log2FoldChange
resDF1$Fold_Change = ifelse(log2FC1 > 0, 2 ^ log2FC1, -1 / (2 ^ log2FC1))
write.xlsx(resDF1,file="DESEQ2/DEG_after_batch_correction.xlsx", row.names = FALSE)


#DESEQ2 analysis with adjusted_counts after removing two samples
#according to this paper combat_seq adjusted count can be pass down to edgeR or DESEQ2
#https://academic.oup.com/nargab/article/2/3/lqaa078/5909519
#https://support.bioconductor.org/p/9138767/
#remove two sample info from sampleInfo object
sampleInfo1=data.frame(sample_name=dput(as.character(names(feature_count)[c(1:8,11,12)])),
                      sample_type=dput(as.character(names(feature_count)[c(1:8,11,12)])),
                      sample_group=dput(as.character(c(rep("T0",6),rep("T100",4)))),
                      batch_number=c("B2","B1","B1","B2","B2","B1","B1","B1","B1","B2"))

group <- data.frame(sample_group=sampleInfo1$sample_group,batch_number=sampleInfo1$batch_number )

dds <- DESeqDataSetFromMatrix(countData=adjusted_counts[,c(1:8,11,12)],
                              colData=group,
                              design=~sample_group)

dds$sample_group <-relevel(dds$sample_group,ref="T0")
dds_wald <- DESeq(dds, betaPrior=FALSE, minReplicatesForReplace=Inf)
res <- results(dds_wald, contrast=c("sample_group","T100","T0"))

feature_annotation <- cbind(GeneID=rownames(feature_count1),gene_name=feature_count1$gene_name)
resDF <- data.frame(GeneID=rownames(res),res)
resDF <- merge(feature_annotation,resDF, by="GeneID")

resDF1 <- subset(resDF, pvalue <= 0.05)
#order on FDR
resDF1 <- resDF1[order(resDF1$pvalue),]
log2FC1 <- resDF1$log2FoldChange
resDF1$Fold_Change = ifelse(log2FC1 > 0, 2 ^ log2FC1, -1 / (2 ^ log2FC1))
write.xlsx(resDF1,file="DESEQ2/DEG_after_batch_correction_and_two_samples_removed.xlsx", row.names = FALSE)


##########
#JUNK CODE
##########
#PLOT PCA AFTER ACCOUNTING FOR BATCH IN DE ANALYSIS
feature_count2 <- feature_count[rowSums(feature_count[])>0,]
dds <- DESeqDataSetFromMatrix(countData=feature_count2,
                              colData=group,
                              design=~batch_number+sample_group)
vsd <- vst(dds,blind=FALSE)
pcaData <- plotPCA(vsd, intgroup=c("batch_number", "sample_group"), returnData=TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))
nudge <- position_nudge(y = 0.5)
ggplot(pcaData, aes(PC1, PC2, color=sample_group, shape = batch_number)) +
  geom_point(size=3) +
  xlab(paste0("PC1: ",percentVar[1],"% variance")) +
  ylab(paste0("PC2: ",percentVar[2],"% variance")) +
  geom_text(aes(label=sampleInfo$sample_name),color="black", position = nudge, size=2.0)
