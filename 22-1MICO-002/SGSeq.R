library(SGSeq)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
library(GenomicRanges)

setwd('/Users/hxo752/Desktop/core-projects/22-1MICO-002_analysis_by_shahina/')
#sample_info <- data.frame(sample_name="sample1",file_bam="/datastore/NGSF001/projects/22-1MICO-002/alignment_twopass/MNG21-91363-P/Aligned.sorted.out.bam")

#getBamInfo from the original bam file
#bam_info <- getBamInfo(sample_info, yieldSize = NULL, cores = 1)
#bam_info=data.frame(file_bam="/datastore/NGSF001/projects/22-1MICO-002/alignment_twopass/MNG21-91363-P/Aligned.sorted.out.bam",paired_end=TRUE, read_length=150, frag_length=268, lib_size=29839281)

#use original bamInfo with bam file only created with chr9 info
#copied bam files from 22-1MICO-002 to /Users/hxo752/Library/R/x86_64/4.1/library/SGSeq/extdata/bams/ to run it with sgseq
#accessing bam file from 22-1MICO-002 and running it with sgseq is not working
bam_info=data.frame(sample_name="sample1",file_bam="/Users/hxo752/Library/R/x86_64/4.1/library/SGSeq/extdata/bams/notch1_reads_sort.bam",paired_end=TRUE, read_length=150, frag_length=268, lib_size=29839281)

txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene
txdb <- keepSeqlevels(txdb, "chr9")

#chr9:136494433-136546048
gr <- GRanges("chr9", IRanges(136494433:136546048))

txf_ucsc <- convertToTxFeatures(txdb)
txf_ucsc <- txf_ucsc[txf_ucsc %over% gr]
head(txf_ucsc)

#Splice graph analysis based on annotated transcripts
sgfc_ucsc <- analyzeFeatures(bam_info, features = txf_ucsc)
sgfc_ucsc

colData(sgfc_ucsc)
rowRanges(sgfc_ucsc)
head(counts(sgfc_ucsc))
head(FPKM(sgfc_ucsc))

pdf("SG_based_on_annotated_transcripts.pdf", width=40)
plotFeatures(sgfc_ucsc, geneName = 4851)
#plotFeatures(sgfc_ucsc, geneName = 4851,  include = "junctions")
#plotFeatures(sgfc_ucsc, geneName = 4851, include = "exons")
#plotFeatures(sgfc_ucsc, geneName = 4851, include = "both")
dev.off()

pdf("coverage_SG_based_on_annotated_transcripts.pdf", width=30)

par(mfrow = c(5, 1), mar = c(1, 3, 1, 1))
plotSpliceGraph(rowRanges(sgfc_ucsc), geneName = 4851, toscale = "none", color_novel = "red")
for (j in 1:4) {
  plotCoverage(sgfc_ucsc[, j], geneName = 4851, toscale = "none")
}
dev.off()


#Splice graph analysis based on de novo prediction
sgfc_pred <- analyzeFeatures(bam_info, which=gr)
head(rowRanges(sgfc_pred))

sgfc_pred <- annotate(sgfc_pred, txf_ucsc)
head(rowRanges(sgfc_pred))

pdf("SG_denovo_prediction.pdf", width=50)
  plotFeatures(sgfc_pred, geneName = 4851, color_novel = "red")
dev.off()


#Splice variant identification
#sgvc_pred <- analyzeVariants(sgfc_pred)
#variantFreq(sgvc_pred)

#Splice variant quantification
#variantFreq(sgvc_pred)

#plotVariants(sgvc_pred, eventID = 4, color_novel = "red")


#Splice variant interpretation
#library(BSgenome.Hsapiens.UCSC.hg38)
#seqlevelsStyle(Hsapiens) <- "NCBI"

