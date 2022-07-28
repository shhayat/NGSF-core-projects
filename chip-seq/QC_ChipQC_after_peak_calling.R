#https://github.com/hbctraining/Intro-to-ChIPseq/blob/master/lessons/06_combine_chipQC_and_metrics.md
library(ChIPQC)
dir.create("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/QC/ChIPQC")
setwd("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/QC/ChIPQC")

#create sample infor object
sampl_info <- read.table("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/sampleSheet_for_chiqQC.txt", 
                         header=TRUE, sep="\t")

#Create ChIPQC object
chipObj <- ChIPQC(sampl_info, annotation="mm10") 

# Create ChIPQC report
ChIPQCreport(chipObj, reportName="ChIPQC Report", reportFolder="QC")
