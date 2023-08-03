library(ChIPseeker)
library(clusterProfiler)
#library(EnsDb.Mmusculus.v79)
library(org.Mm.eg.db)
library(diffloop)

library(TxDb.Mmusculus.UCSC.mm10.knownGene)
txdb <- TxDb.Mmusculus.UCSC.mm10.knownGene

dir.create("/globalhome/hxo752/HPC/23-1DEAN-001/analysis/peak_annotation")
setwd("/globalhome/hxo752/HPC/23-1DEAN-001/analysis/peak_annotation")
#list bed files
samplefiles <- list.files("/globalhome/hxo752/HPC/23-1DEAN-001/analysis/IDR/", pattern= "filtered.bed", full.names=T)
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
peakAnnoList <- lapply(PeakList_with_added_chr_str, annotatePeak, TxDb=txdb,tssRegion=c(-2000, 2000), 
                       verbose=TRUE, annoDb="org.Mm.eg.db")


#annotations for each peaks stored in dataframe
annot_df <- data.frame(peakAnnoList[[1]]@anno)

#selected columns
annot_df=annot_df[c(1:5,23:33)]

#add gene name to annot_df
write.csv(annot_df, "peaks_with_annotations.csv")


pdf("chip_profile.pdf")
 #coverage plot 
 covplot(PeakList_with_added_chr_str[[1]], weightCol="V5")

 #from cov plot we saw most of the peaks are at chr 19. we check cov plot for chr 19
 covplot(PeakList_with_added_chr_str[[1]], weightCol="V5", chrs=c("chr19"))

 #Profile of ChIP peaks binding to TSS regions
  promoter <- getPromoters(TxDb=txdb, upstream=2000, downstream=2000)
  tagMatrix <- getTagMatrix(PeakList_with_added_chr_str[[1]], windows=promoter)

  # preparing tagMatrix list
  tagMatrixList <- list(GE1=tagMatrix)
  
  # plotting tagMatrix heatmap
  tagHeatmap(tagMatrixList, xlim=c(-2000, 2000), color=NULL)

  # plotting average profile of ChIP peaks 
  plotAvgProf(tagMatrixList, xlim=c(-2000, 2000), xlab="Genomic Region (5'->3')", ylab = "Read Count Frequency")

dev.off()


#annotation plot : there are more plot funtion available for multiple cell line comparisions
pdf("annotation_plots.pdf")
  #Barchart of genomic feature representation
  plotAnnoBar(peakAnnoList)

  #To view full annotation overlaps
  #two packages (ggupset,ggimage) were installed separatly for running upsetplot 
  upsetplot(peakAnnoList[[1]] , vennpie=TRUE)
  
  #Distribution of TF-binding loci relative to TSS
  plotDistToTSS(peakAnnoList, title="Distribution of transcription factor-binding loci \n relative to TSS")

dev.off()
