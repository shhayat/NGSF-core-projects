#https://github.com/hbctraining/Intro-to-ChIPseq/blob/master/lessons/06_combine_chipQC_and_metrics.md
library(ChIPQC)
dir.create("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/QC/ChIPQC")
setwd("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/QC")

# reading in the sample information (metadata)
sampl_info <- read.csv("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/sampleSheet_for_chiqQC.csv")

#Create ChIPQC object
chipObj <- ChIPQC(sampl_info, annotation="mm10") 

# Create ChIPQC report
ChIPQCreport(chipObj, reportName="ChIPQC Report", reportFolder="ChIPQC")
