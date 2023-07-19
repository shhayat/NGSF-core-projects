library("DESeq2")
library("xlsx")
library("ggplot2")


setwd("/Users/shahina/Projects/23-1SUUN-001/")
dir.create("DESEQ2", recursive=TRUE, showWarnings = FALSE) 

load("feature_count.RData")
feature_count1 <- as.data.frame(feature_count)

feature_count <- feature_count1[3:14]

sampleInfo=data.frame(sample_name=dput(as.character(names(feature_count))),
                      sample_type=dput(as.character(names(feature_count))),
                      sample_group=dput(as.character(c(rep("T0",6),rep("T100",6)))),
                      batch_number=c("B2","B1","B1","B2","B2","B1","B1","B1","B1","B2","B1","B2"))


group <- data.frame(sample_group=sampleInfo$sample_group,batch_number=sampleInfo$batch_number )



#PCA BEFORE BATCH REMOVAL
dds <- DESeqDataSetFromMatrix(countData=feature_count,
                              colData=group,
                              design=~sample_group)
rld1 <- rlog(dds, blind=FALSE)
nudge <- position_nudge(y = 0.5)
p <- plotPCA(rld1,intgroup=c("sample_group"))
p2 <- p + geom_text(aes_string(label = "name"), color="black", position = nudge, size=3.0)
p2

#PCA AFTER BATCH REMOVAL
dds <- DESeqDataSetFromMatrix(countData=feature_count,
                              colData=group,
                              design=~batch_number+sample_group)

rld <- rlog(dds, blind=FALSE)
assay(rld) <- limma::removeBatchEffect(assay(rld), rld$batch_number)
nudge <- position_nudge(y = 0.5)
p <- plotPCA(rld,intgroup=c("sample_group", "batch_number"))
p1 <- p + geom_text(aes_string(label = "name"), color="black", position = nudge, size=2.0)
p1
