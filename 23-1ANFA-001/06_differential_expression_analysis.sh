#Finding markers differentailly expressed between conditions
library(Seurat)
library(magrittr)
library(dplyr)
library(tibble)

# Load the feature barcode matrix (.mtx)
setwd("/Users/shahina/Projects/23-1ANFA-001/aggregate/")

DEG <- function(condition1, condition2, comparison_name){
data_dir <- paste(comparison_name,"/outs/count/filtered_feature_bc_matrix", sep="")
expression_matrix <- Read10X(data.dir = data_dir)
# Create a Seurat object
SeuratObject <- CreateSeuratObject(counts = expression_matrix,min.cells = 3,names.delim = "-", names.field = 2)

#metadata_by_sample <- data.frame(orig.ident = Idents(SeuratObject))
#metadata$barcodes <- rownames(metadata)

#For creating metadata manually use following steps and then add metadata to seurat object
# Create dataframe by sample that contains matching orig.ident code
metadata_by_sample <- tibble::tribble(~orig.ident,  ~sample_name, 
                                  1, condition1,
                                  2, condition2)

# Change orig.ident column to factor so that it can be joined later
metadata_by_sample$orig.ident <- as.factor(metadata_by_sample$orig.ident)

# Pull existing meta data where samples are specified by orig.ident and remove everything but orig.ident
#OBJ_metadata <- SeuratObject@meta.data %>% 
#  select(orig.ident) %>% 
#  rownames_to_column("barcodes")
metadata <- SeuratObject@meta.data  # Access metadata

# Selecting specific columns (e.g., orig.ident) and adding rownames as 'barcodes'
OBJ_metadata <- data.frame(
  barcodes = rownames(metadata),
  orig.ident = metadata$orig.ident)

# Use full join with object meta data in x position so that by sample meta dataframe is propagated across the by cell meta dataframe from the object.  And then remove orig.ident because it's already present in object meta data.
full_new_meta <- full_join(x = OBJ_metadata, y = metadata_by_sample) %>% 
  column_to_rownames("barcodes") %>% 
  select(-orig.ident)

#Add Metadata
SeuratObject<- AddMetaData(SeuratObject, full_new_meta)
#head(SeuratObject@meta.data)
de.markers <- FindMarkers(SeuratObject, ident.1 = "2", ident.2 = "1")
de <- de.markers[de.markers$p_val <= 0.05,] 
de1 <- data.frame(gene=rownames(de),de)
write.csv(de1,file=sprintf("%s/DEG_%s_vs_%s_filter_on_pval0.05.csv",comparison_name,condition2,condition1),quote=FALSE, row.names = FALSE)
}

DEG("LoopC","LoopM","Comparision1")
DEG("LoopC","LoopM","Comparision2")
DEG("LoopC","LoopM","Comparision3")
DEG("LoopC","DPP1","Comparision4")
DEG("LoopC","DPP1","Comparision5")
DEG("LoopC","DPP1","Comparision6")
DEG("DPP1","CPP1","Comparision7")



#TEST
#Activate conda env
conda activate /globalhome/hxo752/HPC/anaconda3/envs/r-seurat
#Start R in terminal
R
library(Seurat)

# Load the feature barcode matrix (.mtx)
setwd("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANFA-001/analysis/agreggate")
data_dir <- paste("Comparision1","/agreggate/outs/count/filtered_feature_bc_matrix", sep="")
expression_matrix <- Read10X(data.dir = data_dir)
# Create a Seurat object
SeuratObject <- CreateSeuratObject(counts = expression_matrix,min.cells = 3,names.delim = "-", names.field = 2)
SeuratObject[["RNA"]]@counts<-as.matrix(SeuratObject[["RNA"]]@counts)+1
#DESEQ2 aanalysis using Seurat
de.markers <- FindMarkers(SeuratObject, ident.1 = c("3","4"), ident.2 = c("1","2"),   test.use = "DESeq2", slot = "counts")

