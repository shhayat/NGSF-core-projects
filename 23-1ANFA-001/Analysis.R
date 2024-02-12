#https://satijalab.org/seurat/archive/v3.0/pbmc3k_tutorial.html
#https://github.com/hbctraining/scRNA-seq_online/tree/master/lessons
#https://www.sciencedirect.com/science/article/pii/S2090123221002289#s0010
library(Seurat)
library(magrittr)
library(dplyr)
library(tibble)

# Load the feature barcode matrix (.mtx)
setwd("Desktop/core-projects/23-1ANFA-001/count_files/")

data_dir1 <- paste("SC2300017","/raw_feature_bc_matrix", sep="")
data_dir2 <- paste("SC2300013","/raw_feature_bc_matrix", sep="")

expression_49loopC <- Read10X(data.dir = data_dir1)
expression_49DPP1 <- Read10X(data.dir = data_dir2)

# Create a Seurat object
obj_49loopC <- CreateSeuratObject(counts = expression_49loopC,min.features=100,names.delim = "-", names.field = 2)
obj_49DPP1 <- CreateSeuratObject(counts = expression_49DPP1,min.features=100,names.delim = "-", names.field = 2)


#Perform Batch Correction



#
