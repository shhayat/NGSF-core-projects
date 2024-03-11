setwd("/Users/shahina/Projects/23-1LICH-001")

library("edgeR")
library("xlsx")


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
 # resDF2 <- resDF1[resDF1$PValue <= 0.05,]
  #write.xlsx(resDF2,file=sprintf("DEG_%s_vs_%s.xlsx",cond2,cond1), row.names = FALSE)
  write.xlsx(resDF1,file=sprintf("DEG_%s_vs_%s.xlsx",cond2,cond1), row.names = FALSE)
}

#A3A_I5 vs A3A_U6 (n=2)
edgeR_analysis(c(6,4),"A3A_U6","A3A_I5","A3A_U6")
#A3B_I5 vs A3B_U5 (n=2)
edgeR_analysis(c(8,10),"A3B_U5","A3B_I5","A3B_U5")
#A3H_I4 vs A3H_U1 (n=2)
edgeR_analysis(c(13,12),"A3H_U1","A3H_I4","A3H_U1")
#A3A_I4 vs A3A_U1 (n=2)
edgeR_analysis(c(5,3),"A3A_U1","A3A_I4","A3A_U1")
#A3B_I2 vs A3B_U1 (n=2)
edgeR_analysis(c(9,7),"A3B_U1","A3B_I2","A3B_U1")
#A3H_I1 vs A3H_U2 (n=2)
edgeR_analysis(c(14,11),"A3H_U2","A3H_I1","A3H_U2")
