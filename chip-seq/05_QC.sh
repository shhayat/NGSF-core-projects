#https://github.com/hbctraining/Intro-to-ChIPseq/blob/master/lessons/06_combine_chipQC_and_metrics.md
library(ChIPQC)
setwd("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis")
dir.create("QC")
#create sample infor object
sampl_info <- read.table(sampleSheet_for_chiqQC.txt)

View(sampl_info)

#Create ChIPQC object
chipObj <- ChIPQC(sampl_info, annotation="mm10") 

# Create ChIPQC report
ChIPQCreport(chipObj, reportName="ChIPQC Report", reportFolder="QC")
