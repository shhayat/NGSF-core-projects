library(ChIPseeker)
library(clusterProfiler)
library(org.Hs.eg.db)
library(ggupset)
library(ggimage)

library(TxDb.Hsapiens.UCSC.hg38.knownGene)
txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene

#dir.create("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/peak_annotation")
#setwd("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/peak_annotation")
#list bed files
#samplefiles <- list.files("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/chipr", pattern= "optimal_filtered.bed", full.names=T)

#first remove random chr regions from file

BT549_df <- read.table("/Users/shahina/Projects/23-1DEAN-001/chipr/BT549_optimal_filtered.bed")
HCC1806_df <- read.table("/Users/shahina/Projects/23-1DEAN-001/chipr/HCC1806_optimal_filtered.bed")

BT549_df<- BT549_df[!grepl("_random",BT549_df$V1),]
BT549_df<- BT549_df[!grepl("chrUn",BT549_df$V1),]

HCC1806_df <- HCC1806_df[!grepl("_random",HCC1806_df$V1),]
HCC1806_df <- HCC1806_df[!grepl("chrUn",HCC1806_df$V1),]

names(HCC1806_df) <- NULL
names(BT549_df) <- NULL

write.table(HCC1806_df,"/Users/shahina/Projects/23-1DEAN-001/chipr/HCC1806_optimal_filtered_v1.bed", row.names = FALSE, quote=FALSE, sep="\t")
write.table(BT549_df,"/Users/shahina/Projects/23-1DEAN-001/chipr/BT549_optimal_filtered_v1.bed", row.names = FALSE, quote=FALSE, sep="\t")

dir.create("/Users/shahina/Projects/23-1DEAN-001/peak_annotation")
setwd("/Users/shahina/Projects/23-1DEAN-001/peak_annotation")
samplefiles <- list.files("/Users/shahina/Projects/23-1DEAN-001/chipr", pattern="optimal_filtered_v1.bed", full.names=T)

samplefiles <- as.list(samplefiles)
names(samplefiles) <- c("BT549","HCC1806")

#read peaks
ReadPeakList <- lapply(samplefiles, readPeakFile)

#checking seqlevels for ReadPeakList
lapply(ReadPeakList, GenomeInfoDb::seqlevels)
GenomeInfoDb::seqlevels(txdb)
#[1] "chr1"                 "chr2"                 "chr3"      ...          


#since seqlevels for txdb has chr string before chromosome number we have to add chr string to our peaks column 1
#PeakList_with_added_chr_str <- lapply(ReadPeakList, diffloop::addchr)

#annotate peaks
#select 4kbp upstream (-4000) to TSS (0)
peakAnnoList <- lapply(ReadPeakList, annotatePeak, TxDb=txdb,tssRegion=c(-4000, 0), 
                       verbose=TRUE, annoDb="org.Hs.eg.db")


#annotations for each peaks stored in dataframe
annot_df_BT549 <- data.frame(peakAnnoList[[1]]@anno)
annot_df_HCC1806 <- data.frame(peakAnnoList[[2]]@anno)

#selected columns
#annot_df_BT549=annot_df_BT549[c(1:5,23:33)]
#annot_df_HCC1806=annot_df_HCC1806[c(1:5,23:33)]

BT549_promotor <- annot_df_BT549[grepl("Promoter",annot_df_BT549$annotation),][-c(6,7,8,9,10,11)]
HCC1806_promotor <- annot_df_HCC1806[grepl("Promoter",annot_df_HCC1806$annotation),][-c(6,7,8,9,10,11)]

#add gene name to annot_df
write.csv(BT549_promotor, "BT549_peaks_with_annotations_for_promoters.csv")
write.csv(HCC1806_promotor, "HCC1806_peaks_with_annotations_for_promoters.csv")

#common peaks between BT549 and HCC1806
common <- merge(HCC1806_promotor,BT549_promotor, by=c("geneId"), suffix=c(".HCC1806",".BT549"))
write.csv(common, "common_peaks_with_annotations_for_promoters.csv")


pdf("BT549_chip_profile.pdf")

#Profile of ChIP peaks binding to TSS regions
promoter <- getPromoters(TxDb=txdb, upstream=4000, downstream=4000)
tagMatrix <- getTagMatrix(ReadPeakList$BT549, windows=promoter)
# preparing tagMatrix list
tagMatrixList <- list(BT549=tagMatrix)
# plotting tagMatrix heatmap
#tagHeatmap(tagMatrixList)

#profile
peakHeatmap(peak = ReadPeakList$BT549, TxDb = txdb,upstream = 4000, downstream = 4000)

# plotting average profile of ChIP peaks 
plotAvgProf(tagMatrixList, xlim=c(-4000, 4000), xlab="Genomic Region (5'->3')", ylab = "Read Count Frequency")


#plot heatmap and peak profiling together
#peak_Profile_Heatmap(peak = samplefiles$BT549, upstream = 2000,downstream = 2000,by = "gene",type = "start_site",
   #                  TxDb = txdb,nbin = 800)

plotPeakProf2(peak = ReadPeakList$BT549, upstream = rel(0.2), downstream = rel(0.2),conf = 0.95, by = "gene", 
              type = "body", nbin = 1000, TxDb = txdb, weightCol = "V5",ignore_strand = F)
dev.off()



#annotation plot : there are more plot funtion available for multiple cell line comparisions
pdf("BT549_annotation_plots.pdf")
#Barchart of genomic feature representation
#plotAnnoBar(peakAnnoList$BT549)
plotAnnoPie(peakAnnoList$BT549)

#To view full annotation overlaps
upsetplot(peakAnnoList$BT549, vennpie=TRUE)

#Distribution of TF-binding loci relative to TSS
#plotDistToTSS(peakAnnoList$BT549, title="Distribution of transcription factor-binding loci \n relative to TSS")

dev.off()



pdf("HCC1806_chip_profile.pdf")
#coverage plot 
#Profile of ChIP peaks binding to TSS regions
promoter <- getPromoters(TxDb=txdb, upstream=4000, downstream=4000)
tagMatrix <- getTagMatrix(ReadPeakList$HCC1806, windows=promoter)
# preparing tagMatrix list
tagMatrixList <- list(HCC1806=tagMatrix)
# plotting tagMatrix heatmap
#tagHeatmap(tagMatrixList)

#profile
peakHeatmap(peak = ReadPeakList$HCC1806, TxDb = txdb,upstream =4000, downstream =4000)

# plotting average profile of ChIP peaks 
plotAvgProf(tagMatrixList, xlim=c(-4000, 4000), xlab="Genomic Region (5'->3')", ylab = "Read Count Frequency")


#plot heatmap and peak profiling together
#peak_Profile_Heatmap(peak = samplefiles$BT549, upstream = 2000,downstream = 2000,by = "gene",type = "start_site",
#                  TxDb = txdb,nbin = 800)

plotPeakProf2(peak = ReadPeakList$HCC1806, upstream = rel(0.2), downstream = rel(0.2),conf = 0.95, by = "gene", 
              type = "body", nbin = 1000, TxDb = txdb, weightCol = "V5",ignore_strand = F)
dev.off()


#annotation plot : there are more plot funtion available for multiple cell line comparisions
pdf("HCC1806_annotation_plots.pdf")
#Barchart of genomic feature representation
#plotAnnoBar(peakAnnoList$HCC1806)
plotAnnoPie(peakAnnoList$HCC1806)
#To view full annotation overlaps
#two packages (ggupset,ggimage) were installed separatly for running upsetplot 
upsetplot(peakAnnoList$HCC1806 , vennpie=TRUE)

#Distribution of TF-binding loci relative to TSS
#plotDistToTSS(peakAnnoList$HCC1806, title="Distribution of transcription factor-binding loci \n relative to TSS")
dev.off()


####################
#COMPARISION PLOTS
####################

#Venn Diagram for BT549 and HCC1806 promoters
library(VennDiagram)
library(RColorBrewer)

myCol <- brewer.pal(2, "Pastel2")
#venn diagram on raw data (three conditions)

HCC1806_df <- HCC1806_promotor$geneId
BT549_df <- BT549_promotor$geneId


display_venn <- function(x, ...){
  library(VennDiagram)
  grid.newpage()
  venn_object <- venn.diagram(x, filename = NULL, ...)
  grid.draw(venn_object)
}                                  

pdf("VennDiagram.pdf")                                  
display_venn(
  list(HCC1806=HCC1806_df,BT549=BT549_df ),
  category.names = c("HCC1806" , "BT549"),
  fill = c("#999999", "#E69F00")
)                                 
dev.off()



#compare their genomic annotation of two cell lines
pdf("compare_genomic_annotations.pdf")
  plotAnnoBar(peakAnnoList)
dev.off()

#compare distance to TSS of two cell lines
pdf("compare_dist_to_tss.pdf")
  plotDistToTSS(peakAnnoList)
dev.off()

#compare peak heatmaps
pdf("compare_Peak_heatmaps.pdf", width=200, height=400)
  promoter <- getPromoters(TxDb=txdb, upstream=4000, downstream=4000)
  tagMatrix1 <- getTagMatrix(ReadPeakList$BT549, windows=promoter)
  tagMatrix2 <- getTagMatrix(ReadPeakList$HCC1806, windows=promoter)
  # preparing tagMatrix list
  tagMatrixList <- list(BT549=tagMatrix1,HCC1806=tagMatrix2)
  tagHeatmap(tagMatrixList)
dev.off()

#plot average profile
pdf("compare_avg_profile.pdf")
  plotAvgProf(tagMatrixList, xlim=c(-4000, 4000), conf=0.95,resample=500, facet="row")
dev.off()


p1 <- covplot(ReadPeakList,chrs=c("chr1", "chr2","chr3", "chr4","chr5", "chr6","chr7", "chr8","chr9","chr10"))
p2 <- covplot(ReadPeakList,chrs=c("chr11", "chr12","chr13", "chr14","chr15", "chr16","chr17", "chr18","chr19","chr20"))
#coverage plot
pdf("coveragePlot.pdf", width=20)
  col <- c(BT549='red', HCC1806='blue')
  p1 + facet_grid(chr ~ .id) + scale_color_manual(values=col) + scale_fill_manual(values=col)
  p2 + facet_grid(chr ~ .id) + scale_color_manual(values=col) + scale_fill_manual(values=col)
dev.off()



##############################################
#select promoter regions for Motif Discovery
##############################################

BT549_promotor <- annot_df_BT549[grepl("Promoter",annot_df_BT549$annotation),][,1:3]
HCC1806_promotor <- annot_df_HCC1806[grepl("Promoter",annot_df_HCC1806$annotation),][,1:3]

names(BT549_promotor) <- NULL
names(HCC1806_promotor) <- NULL
write.table(BT549_promotor,"/Users/shahina/Projects/2023_projects/23-1DEAN-001/chipr/BT549_promotor_regions.bed", row.names = FALSE, quote=FALSE, sep="\t")
write.table(HCC1806_promotor,"/Users/shahina/Projects/2023_projects/23-1DEAN-001/chipr/HCC1806_promotor_regions.bed", row.names = FALSE, quote=FALSE, sep="\t")

##############################################
#select common promoter regions for Motif Discovery
##############################################

BT549_promotor <- annot_df_BT549[grepl("Promoter",annot_df_BT549$annotation),][,c(1:3,18)]
HCC1806_promotor <- annot_df_HCC1806[grepl("Promoter",annot_df_HCC1806$annotation),][,c(1:3,18)]


HCC1806_common <- HCC1806_promotor[HCC1806_promotor$geneId %in% BT549_promotor$geneId,][,c(1:3)]
BT549_common <- BT549_promotor[BT549_promotor$geneId %in% HCC1806_promotor$geneId,][,c(1:3)]


names(HCC1806_common) <- NULL
names(BT549_common) <- NULL

write.table(BT549_common,"/Users/shahina/Projects/2023_projects/23-1DEAN-001/chipr/BT549_promotor_regions_common.bed", row.names = FALSE, quote=FALSE, sep="\t")
write.table(HCC1806_common,"/Users/shahina/Projects/2023_projects/23-1DEAN-001/chipr/HCC1806_promotor_regions_common.bed", row.names = FALSE, quote=FALSE, sep="\t")
