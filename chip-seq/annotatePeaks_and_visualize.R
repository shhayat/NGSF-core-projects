#library(DiffBind)
library(ChIPseeker)
library(clusterProfiler)
library(biomaRt)

library(org.Mm.eg.db)
library(TxDb.Mmusculus.UCSC.mm10.knownGene)
txdb <- TxDb.Mmusculus.UCSC.mm10.knownGene


samplefiles <- list.files("/globalhome/hxo752/HPC/chipseq/analysis/IDR/", pattern= ".bed", full.names=T)
peak <- readPeakFile(samplefiles[[0]])

samplefiles <- as.list(samplefiles)
names(samplefiles) <- c("G1E")


#ChIP peaks coverage plot
#4000bp = 2Kbp
peakAnnoList <- lapply(samplefiles, annotatePeak, TxDb=txdb, 
                       tssRegion=c(-2000, 2000), verbose=TRUE)
                       


#Profile of ChIP peaks binding to TSS regions
# extracting peaks present across replicates
peaks <- peaks.consensus[called.peaks[,1]==1 & called.peaks[,2]==1]
