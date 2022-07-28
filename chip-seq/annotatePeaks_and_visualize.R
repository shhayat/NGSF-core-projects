library(ChIPseeker)
library(clusterProfiler)
library(biomaRt)

library(org.Mm.eg.db)
library(TxDb.Mmusculus.UCSC.mm10.knownGene)
txdb <- TxDb.Mmusculus.UCSC.mm10.knownGene


samplefiles <- list.files("/globalhome/hxo752/HPC/chipseq/analysis/IDR/", pattern= "filtered.bed", full.names=T)
peaks <- readPeakFile(samplefiles[[1]])
names(peaks) <- c("G1E")

GenomeInfoDb::seqlevels(peak)
#[1] "11" "7"  "8"  "19" "16" "4"  "10" "X"  "6"  "5"  "15" "2"  "1"  "9"  "12"

GenomeInfoDb::seqlevels(txdb)
#[1] "chr1"                 "chr2"                 "chr3"      ...          


#since seqlevels for txdb has chr string before chromosome number we have to add chr string to our peaks column 1




#ChIP peaks coverage plot
#4000bp = 2Kbp
peakAnnoList <- lapply(peaks, annotatePeak, TxDb=txdb, 
                       tssRegion=c(-2000, 2000), verbose=TRUE)
                       


#Profile of ChIP peaks binding to TSS regions
# extracting peaks present across replicates
peaks <- peaks.consensus[called.peaks[,1]==1 & called.peaks[,2]==1]
