#https://github.com/hbctraining/Intro-to-ChIPseq/blob/master/lessons/06_combine_chipQC_and_metrics.md

library(ChIPQC)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
library(DiffBind)

dir.create("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/QC/ChIPQC")
setwd("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/QC")

# reading in the sample information (metadata)
sampl_info <- read.csv("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/sampleSheet_for_ChIPQC_v1.csv")

res=dba(sampleSheet=sampl_info, config=data.frame(RunParallel=FALSE))

#Create ChIPQC object
resQC = ChIPQC(res,annotation="hg38", config=data.frame(RunParallel=FALSE))

# Create ChIPQC report
ChIPQCreport(resQC, reportName="ChIPQC Report", reportFolder="ChIPQC")
