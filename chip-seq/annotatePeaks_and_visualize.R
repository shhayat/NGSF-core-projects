library(ChIPseeker)
library(clusterProfiler)
library(biomaRt)
library(diffloop)

library(org.Mm.eg.db)
library(TxDb.Mmusculus.UCSC.mm10.knownGene)
txdb <- TxDb.Mmusculus.UCSC.mm10.knownGene

dir.create("/globalhome/hxo752/HPC/chipseq/analysis/visulaization")
setwd("/globalhome/hxo752/HPC/chipseq/analysis/peak_annotation")
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

#coverage plot
pdf("coverage_plots")
covplot(peakAnnoList, weightCol="V5")
dev.off()

#annotation plot : there are more plot funtion available for multiple cell line comparisions
pdf("annotation_plots")
  #Barchart of genomic feature representation
  plotAnnoBar(peakAnnoList)

  #To view full annotation overlaps
  upsetplot(eakAnnoList[[1]] , vennpie=TRUE))
  
  #Distribution of TF-binding loci relative to TSS
  plotDistToTSS(peakAnnoList, title="Distribution of transcription factor-binding loci \n relative to TSS")

  
  promoter <- getPromoters(TxDb=txdb, upstream=2000, downstream=2000)

  #Heatmap of ChIP binding to TSS regions
  #tagHeatmap(PeakList_with_added_chr_str, xlim=c(-2000, 2000), color="red")

  #Average Profile of ChIP peaks binding to TSS region
  #plotAvgProf(peakAnnoList, xlim=c(-2000, 2000), xlab="Genomic Region (5'->3')", ylab = "Read Count Frequency")
dev.off()


#annotations for each peaks stored in dataframe
annot_df <- data.frame(peakAnnoList[["GE1"]]@anno)


write.csv(annot_df, "peaks_with_annotations.csv", sep="\t")


