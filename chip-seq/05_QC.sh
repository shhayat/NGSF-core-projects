#https://github.com/hbctraining/Intro-to-ChIPseq/blob/master/lessons/06_combine_chipQC_and_metrics.md
library(ChIPQC)

#create sample infor object
sampl_info <- read.table(sampleSheet_for_chiqQC.txt)

View(sampl_info)

#Create ChIPQC object
chipObj <- ChIPQC(sampl_info, annotation="mm10") 

# Create ChIPQC report
ChIPQCreport(chipObj, reportName="ChIP QC Report", reportFolder="ChIPQCreport")


#SampleID,Factor,Replicate,bamReads,ControlID,bamControl,Peaks,PeakCaller,Tissue,Condition
#Nanog.Rep1,Nanog,1,data/bams/H1hesc_Nanog_Rep1_aln.bam,Nanog-Input1,data/bams/H1hesc_Input_Rep1_aln.bam,data/peakcalls/Nanog-rep1_peaks.narrowPeak,narrow,NA,NA
