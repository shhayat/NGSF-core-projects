library(ChIPseeker)
library(clusterProfiler)
library(org.Hs.eg.db)
library(ggupset)
library(ggimage)

library(TxDb.Hsapiens.UCSC.hg38.knownGene)
txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene

dir.create("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/peak_annotation")
setwd("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/peak_annotation")
#list bed files
samplefiles <- list.files("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/chipr", pattern= "optimal_filtered.bed", full.names=T)
samplefiles <- as.list(samplefiles)
names(samplefiles) <- c("BT549","HCC1806")

#read peaks
ReadPeakList <- lapply(samplefiles, readPeakFile)

#checking seqlevels for ReadPeakList
lapply(ReadPeakList, GenomeInfoDb::seqlevels)
#[1] "11" "7"  "8"  "19" "16" "4"  "10" "X"  "6"  "5"  "15" "2"  "1"  "9"  "12"

GenomeInfoDb::seqlevels(txdb)
#[1] "chr1"                 "chr2"                 "chr3"      ...          


#since seqlevels for txdb has chr string before chromosome number we have to add chr string to our peaks column 1
#PeakList_with_added_chr_str <- lapply(ReadPeakList, diffloop::addchr)

#annotate peaks
#2000bp = 2Kbp
peakAnnoList <- lapply(ReadPeakList, annotatePeak, TxDb=txdb,tssRegion=c(-2000, 2000), 
                       verbose=TRUE, annoDb="org.Hs.eg.db")


#annotations for each peaks stored in dataframe
annot_df_BT549 <- data.frame(peakAnnoList[[1]]@anno)
annot_df_HCC1806 <- data.frame(peakAnnoList[[2]]@anno)

#selected columns
#annot_df_BT549=annot_df_BT549[c(1:5,23:33)]
#annot_df_HCC1806=annot_df_HCC1806[c(1:5,23:33)]

#add gene name to annot_df
write.csv(annot_df_BT549, "BT549_peaks_with_annotations.csv")
write.csv(annot_df_HCC1806, "HCC1806_peaks_with_annotations.csv")


pdf("BT549_chip_profile.pdf")
 #coverage plot 
 covplot(ReadPeakList$BT549, weightCol="V5",chrs=c("chr1", "chr2","chr3", "chr4","chr5", "chr6","chr7", "chr8","chr9", 
                                                   "chr10","chr11", "chr12","chr13", "chr14","chr15","chr16", "chr17",
                                                   "chr18","chr19", "chr20","chr21","chr22","chrX","chrY","chrM"))
 #covplot(PeakList_with_added_chr_str[[1]], weightCol="V5", chrs=c("chr19"))

covplot(ReadPeakList$BT549, weightCol="V5",chrs=c("chr1", "chr2","chr3", "chr4","chr5", "chr6","chr7", "chr8","chr9","chr10"))
dev.off()

 #Profile of ChIP peaks binding to TSS regions
  promoter <- getPromoters(TxDb=txdb, upstream=2000, downstream=2000)
  tagMatrix <- getTagMatrix(ReadPeakList$BT549, windows=promoter)

  # preparing tagMatrix list
  tagMatrixList <- list(BT549=tagMatrix)
  
  # plotting tagMatrix heatmap
  tagHeatmap(tagMatrixList, xlim=c(-2000, 2000), color=NULL)

  # plotting average profile of ChIP peaks 
  plotAvgProf(tagMatrixList, xlim=c(-2000, 2000), xlab="Genomic Region (5'->3')", ylab = "Read Count Frequency")

  plotPeakProf2(peak = ReadPeakList$BT549, upstream = rel(0.2), downstream = rel(0.2),conf = 0.95, by = "gene", type = "body", nbin = 1000, TxDb = txdb, weightCol = "V5",ignore_strand = F)
dev.off()

#annotation plot : there are more plot funtion available for multiple cell line comparisions
pdf("BT549_annotation_plots.pdf")
  #Barchart of genomic feature representation
  plotAnnoBar(peakAnnoList$BT549)

  #To view full annotation overlaps
  #two packages (ggupset,ggimage) were installed separatly for running upsetplot 
  upsetplot(peakAnnoList$BT549, vennpie=TRUE)
  
  #Distribution of TF-binding loci relative to TSS
  plotDistToTSS(peakAnnoList$BT549, title="Distribution of transcription factor-binding loci \n relative to TSS")

dev.off()




pdf("HCC1806_chip_profile.pdf")
 #coverage plot 
 covplot(ReadPeakList$HCC1806, weightCol="V5",chrs=c("chr1", "chr2","chr3", "chr4","chr5", "chr6","chr7", "chr8","chr9", 
                                                   "chr10","chr11", "chr12","chr13", "chr14","chr15","chr16", "chr17",
                                                   "chr18","chr19", "chr20","chr21","chr22","chrX","chrY","chrM")) 
 #covplot(PeakList_with_added_chr_str[[1]], weightCol="V5", chrs=c("chr19"))

 #Profile of ChIP peaks binding to TSS regions
  promoter <- getPromoters(TxDb=txdb, upstream=2000, downstream=2000)
  tagMatrix <- getTagMatrix(ReadPeakList$HCC1806, windows=promoter)

  # preparing tagMatrix list
  tagMatrixList <- list(HCC1806=tagMatrix)
  
  # plotting tagMatrix heatmap
  tagHeatmap(tagMatrixList, xlim=c(-2000, 2000), color=NULL)

  # plotting average profile of ChIP peaks 
  plotAvgProf(tagMatrixList, xlim=c(-2000, 2000), xlab="Genomic Region (5'->3')", ylab = "Read Count Frequency")

dev.off()

#annotation plot : there are more plot funtion available for multiple cell line comparisions
pdf("HCC1806_annotation_plots.pdf")
  #Barchart of genomic feature representation
  plotAnnoBar(peakAnnoList$HCC1806)
  #To view full annotation overlaps
  #two packages (ggupset,ggimage) were installed separatly for running upsetplot 
  upsetplot(peakAnnoList$HCC1806 , vennpie=TRUE)
  
  #Distribution of TF-binding loci relative to TSS
  plotDistToTSS(peakAnnoList$HCC1806, title="Distribution of transcription factor-binding loci \n relative to TSS")

dev.off()
