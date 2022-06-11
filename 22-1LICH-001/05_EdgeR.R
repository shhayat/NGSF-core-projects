library("edgeR")

dir.create("/Users/hxo752/Desktop/22-1LICH-001/EdgeR", recursive=TRUE, showWarnings = FALSE) 
setwd("/Users/hxo752/Desktop/22-1LICH-001")

load("feature_count.RData")
feature_count <- as.data.frame(feature_count)
geneID <- gsub(".[0-9]*$", "", rownames(feature_count))
rownames(feature_count) <- geneID


feature_annotation <- feature_count[1:2]
feature_annotation$GeneID <-  gsub(".[0-9]*$", "", feature_annotation$GeneID)

#paired comparisions
edgeR_analysis <-  function(colnum,cond1, cond2, ref)
{
  feature_count <- feature_count[colnum]
  
  #at least one column has number
  feature_count <- feature_count[apply(feature_count,1,function(z) any(z!=0)),]
  
  y <- DGEList(counts=feature_count, group=1:2)
  
  bcv <- 0.01
  et <- exactTest(y, dispersion=bcv^2)
  df <- et$table
  resDF <- data.frame(GeneID=rownames(df),df)
  resDF1 <- merge(feature_annotation,resDF, by="GeneID")
  
  #resDF1$Fold_Change = ifelse(resDF1$logFC > 0, 2 ^ resDF1$logFC, -1 / (2 ^ resDF1$logFC))
  res1 <- resDF1[resDF1$logFC <= -1.5,]
  res2 <-  resDF1[resDF1$logFC >= 1.5,]
  
  res <- rbind(res1,res2)
  #All genes
  write.csv(res,file=sprintf("%s_vs_%s_logFC1.5.csv",cond2,cond1),quote=FALSE, row.names = FALSE)
  
}
edgeR_analysis(c(3:4),"R2200132_Untreated","R2200133_Treated","R2200132_Untreated")
edgeR_analysis(c(5:6),"R2200134_Untreated","R2200135_Treated","R2200134_Untreated")
edgeR_analysis(c(7:8),"R2200136_Untreated","R2200137_Treated","R2200136_Untreated")
