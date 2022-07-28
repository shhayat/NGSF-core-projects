library(ChIPseeker)
library(clusterProfiler)
library(biomaRt)
library(diffloop)

library(org.Mm.eg.db)
library(TxDb.Mmusculus.UCSC.mm10.knownGene)
txdb <- TxDb.Mmusculus.UCSC.mm10.knownGene

#list bed files
samplefiles <- list.files("/globalhome/hxo752/HPC/chipseq/analysis/IDR/", pattern= "filtered.bed", full.names=T)
samplefiles <- as.list(samplefiles)
names(samplefiles) <- c("GE1")

#read peaks
ReadPeakList <- lapply(samplefiles, readPeakFile)

#checking seqlevels for ReadPeakList
lapply(ReadPeakList, GenomeInfoDb::seqlevels)
#[1] "11" "7"  "8"  "19" "16" "4"  "10" "X"  "6"  "5"  "15" "2"  "1"  "9"  "12"

GenomeInfoDb::seqlevels(txdb)
#[1] "chr1"                 "chr2"                 "chr3"      ...          


#since seqlevels for txdb has chr string before chromosome number we have to add chr string to our peaks column 1
PeakList_with_added_chr_str <- lapply(ReadPeakList, diffloop::addchr)

#annotate peaks
#2000bp = 2Kbp
peakAnnoList <- lapply(PeakList_with_added_chr_str, annotatePeak, TxDb=txdb,tssRegion=c(-2000, 2000), verbose=TRUE)

#ChIP peaks coverage plot
