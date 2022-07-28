#library(DiffBind)
library(ChIPseeker)
library(clusterProfiler)
library(biomaRt)

library(org.Mm.eg.db)
library(TxDb.Mmusculus.UCSC.mm10.knownGene)
txdb <- TxDb.Mmusculus.UCSC.mm10.knownGene


samplefiles <- list.files("/globalhome/hxo752/HPC/chipseq/analysis/IDR/", pattern= ".bed", full.names=T)
samplefiles <- as.list(samplefiles)
names(samplefiles) <- c("TAL")

#ChIP peaks coverage plot

peaks.consensus <- dba.peakset(res.cnt3, bRetrieve = T)


#Profile of ChIP peaks binding to TSS regions
# extracting peaks present across replicates
peaks <- peaks.consensus[called.peaks[,1]==1 & called.peaks[,2]==1]
