#Batch Correction
https://www.10xgenomics.com/analysis-guides/batch-effect-correction-in-chromium-single-cell-atac-data

library(Seurat)
library(magrittr)
library(dplyr)
library(tibble)

#https://hbctraining.github.io/scRNA-seq_online/lessons/pseudobulk_DESeq2_scrnaseq.html
# Load the feature barcode matrix (.mtx)
setwd("/Users/shahina/Projects/23-1ANFA-001/count_files/")

data_dir <- paste(comparison_name,"/outs/count/filtered_feature_bc_matrix", sep="")
expression_matrix <- Read10X(data.dir = data_dir)
# Create a Seurat object
SeuratObject <- CreateSeuratObject(counts = expression_matrix,min.cells = 3,names.delim = "-", names.field = 2)

expression_matrix <- Read10X(data.dir = data_dir)
# Create a Seurat object
SeuratObject <- CreateSeuratObject(counts = expression_matrix,min.cells = 3,names.delim = "-", names.field = 2)


SC2300015 vs SC2300013
