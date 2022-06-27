#https://github.com/hbctraining/Intro-to-ChIPseq/blob/master/lessons/06_combine_chipQC_and_metrics.md


library(ChIPQC)

## Load sample data
sampl_info <- data.frame(SampleID = rbind("c","b"), 
                           Factor = rbind("c","b"),
                            Replicate = rbind("c","b"),
                            bamReads = rbind("c","b"),
                            ControlID = rbind("c","b"),
                            bamControl = rbind("c","b"),
                            Peaks = rbind("c","b"),
                            PeakCaller = rbind("c","b"),
                            Tissue = ("NA","NA"),
                            Condition = ("NA","NA"))
                            
 View(sampl_info)
 
#SampleID,Factor,Replicate,bamReads,ControlID,bamControl,Peaks,PeakCaller,Tissue,Condition
#Nanog.Rep1,Nanog,1,data/bams/H1hesc_Nanog_Rep1_aln.bam,Nanog-Input1,data/bams/H1hesc_Input_Rep1_aln.bam,data/peakcalls/Nanog-rep1_peaks.narrowPeak,narrow,NA,NA
