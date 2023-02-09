library("DESeq2")
library("ggplot2")
library("xlsx")

setwd("/Users/shahina/Projects/Fusion_gene_for_ NTRK/")
dir.create("DESEQ2", recursive=TRUE, showWarnings = FALSE) 

feature_count1 <- read.delim("pcbi.1009450.s007.txt")
rownames(feature_count1) <- feature_count1$Ensembl_Gene_ID_Canine
#your first columns which are gene id and gene name
feature_annotation <- feature_count1[1:8]
setwd("/Users/shahina/Projects/Fusion_gene_for_ NTRK/DESEQ2")

  feature_count <- feature_count1[c(9:17,63:71,108:116,153:161,198:206,18:62,72:107,117:152,162:197,207:233)]
  #at least one column has number
  #feature_count <- feature_count[apply(feature_count,1,function(z) any(z!=0)),]
  
  sampleInfo=data.frame(sample_name=dput(as.character(names(feature_count))),
                        sample_type=dput(as.character(names(feature_count))),
                        sample_group=dput(as.character(c(rep("Normal",90),rep("Tumor",135)))))
  

  group <- data.frame(sample_group=sampleInfo$sample_group)
  
  dds <- DESeqDataSetFromMatrix(countData=feature_count,
                                colData=group,
                                design=~sample_group)
  
  
  dds$sample_group <- relevel(dds$sample_group,ref="Normal")
  
  ##########
  #PCA PLOT
  ##########
  #gernate rlog for PCA
  rld <-vst(dds)
  pdf(sprintf("PCA_%s_%s.pdf",cond2,cond1), width=8,height=8)
  nudge <- position_nudge(y = 0.5)
  p <- plotPCA(rld,intgroup=c("sample_group"))  
  p <- p + geom_text(aes_string(label = "name"), color="black", position = nudge, size=2.8)
  print(p)
  dev.off()
  
  dds_wald <- DESeq(dds, betaPrior=FALSE, minReplicatesForReplace=Inf)
  res <- results(dds_wald, contrast=c("sample_group","Tumor","Normal"))
  
  resDF <- data.frame(Ensembl_Gene_ID_Canine=rownames(res),res)
  resDF <- merge(feature_annotation,resDF, by="Ensembl_Gene_ID_Canine")
  #remove rows with all NAs
  #resDF1 <- subset(resDF, pvalue <= 0.05)
  #order on FDR
  
  resDF1 <- resDF[order(resDF$pvalue),]
  log2FC1 <- resDF1$log2FoldChange
  resDF1$Fold_Change = ifelse(log2FC1 > 0, 2 ^ log2FC1, -1 / (2 ^ log2FC1))
  #filter(resDF11, padj <= 0.01)
  #return(dim(resDF1))
  #All significant
  #write.csv(resDF1,file="DEG_Tumor_vs_Normal.csv",quote=FALSE, row.names = FALSE)

  #grep NTRK genes
  ntrk_gene <- resDF1[grep("NTRK",resDF1$Gene_Symbol_Canine),]
  write.xlsx(ntrk_gene,file="DEG_Tumor_vs_Normal_ntrk_gene.xlsx",quote=FALSE, row.names = FALSE)
  
