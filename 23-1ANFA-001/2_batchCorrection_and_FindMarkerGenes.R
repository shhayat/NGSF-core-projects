setwd("/datastore/NGSF001/projects/2023/23-1ANFA-001/analysis/")
library(Seurat)
library(harmony)

load("seuratobject_SC2300009.RData")
SC2300009 <- seuratobject 
SC2300009@meta.data$sample_name <- "DPP1"

load("seuratobject_SC2300010.RData")
SC2300010 <- seuratobject 
SC2300010@meta.data$sample_name <- "CPP1"


load("seuratobject_SC2300011.RData")
SC2300011 <- seuratobject 
SC2300011@meta.data$sample_name <- "DPP1"

load("seuratobject_SC2300012.RData")
SC2300012 <- seuratobject 
SC2300012@meta.data$sample_name <- "CPP1"


load("seuratobject_SC2300013.RData")
SC2300013 <- seuratobject 
SC2300013@meta.data$sample_name <- "DPP1"

load("seuratobject_SC2300014.RData")
SC2300014 <- seuratobject 
SC2300014@meta.data$sample_name <- "CPP1"


load("seuratobject_SC2300015.RData")
SC2300015 <- seuratobject 
SC2300015@meta.data$sample_name <- "loopC"

load("seuratobject_SC2300016.RData")
SC2300016 <- seuratobject 
SC2300016@meta.data$sample_name <- "loopM"

load("seuratobject_SC2300017.RData")
SC2300017 <- seuratobject 
SC2300017@meta.data$sample_name <- "loopC"

load("seuratobject_SC2300018.RData")
SC2300018 <- seuratobject 
SC2300018@meta.data$sample_name <- "loopM"

setwd("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANFA-001/analysis/")

#Check if there is batch effect by integrating different conditions/samples
check_batch_effect_and_find_markers_per_cluster <- function(seuratList,condition_names, conds){
seurat_list1=seuratList

#First merge samples which needs to be compared
merged_seurat <- merge(x=seurat_list1[[1]], y = seurat_list1[2:length(seurat_list1)], add.cell.id = condition_names)

# Find most variable features across samples to integrate
integ_features <- SelectIntegrationFeatures(object.list = seurat_list1, nfeatures = 3000) 
DefaultAssay(merged_seurat) <- "SCT"

# Manually set variable features of merged Seurat object
VariableFeatures(merged_seurat) <- integ_features

# Calculate PCs using manually set variable features
merged_seurat <- RunPCA(merged_seurat, assay = "SCT", npcs = 50)

#Perform dimensional reduction by UMAP
merged_seurat <- RunUMAP(merged_seurat, dims = 1:15, verbose = FALSE)
#plot UMAP
pdf(sprintf("UMAP_%s.pdf",conds))
DimPlot(merged_seurat, group.by="sample_name")
dev.off()

#Find differentially Expressed genes per cluster
markers <- FindAllMarkers(object = merged_seurat,logfc.threshold = 0.25)  

write.table(markers,file=sprintf("%s_marker_genes.txt",conds), row.names = FALSE)
  
}
#for these samples no batch correction was needed as the conditions were integrating well in UMAP 
check_batch_effect_and_find_markers_per_cluster(list(SC2300015,SC2300017,SC2300016,SC2300018),c("loopC","loopC","loopM","loopM"),"LoopC_LoopM")
#no batch correction needed
check_batch_effect_and_find_markers_per_cluster(list(SC2300015,SC2300016),c("loopC","loopM"), "49_loopC_loopM")
#no batch correction needed
check_batch_effect_and_find_markers_per_cluster(list(SC2300011,SC2300017),c("DPP1","loopC"), "48DPP1_49loopC")
#no batch correction needed
check_batch_effect_and_find_markers_per_cluster(list(SC2300015,SC2300013),c("loopC","DPP1"), "49_DPP1_loopC")
#no batch correction needed
check_batch_effect_and_find_markers_per_cluster(list(SC2300015,SC2300017,SC2300009,SC2300011,SC2300013),c("loopC","loopC","DPP1","DPP1","DPP1"),"LoopC_DPP1" )
#batch correction needed
check_batch_effect(list(SC2300009,SC2300011,SC2300013,SC2300010,SC2300012,SC2300014),c("DPP1","DPP1","DPP1","CPP1","CPP1","CPP1"), "DPP1_CPP1")


############################################################################################################
#Batch correction was done for list(SC2300009,SC2300011,SC2300013,SC2300010,SC2300012,SC2300014)
############################################################################################################
#Check if there is batch effect by integrating different conditions/samples
batch_correction_and_find_markers_per_cluster <- function(seuratList,condition_names){
  seurat_list1=seuratList
  
  #First merge samples which needs to be compared
  merged_seurat <- merge(x=seurat_list1[[1]], y = seurat_list1[2:length(seurat_list1)], add.cell.id = condition_names)
  
  # Find most variable features across samples to integrate
  integ_features <- SelectIntegrationFeatures(object.list = seurat_list1, nfeatures = 3000) 
  DefaultAssay(merged_seurat) <- "SCT"
  
  # Manually set variable features of merged Seurat object
  VariableFeatures(merged_seurat) <- integ_features
  
  # Calculate PCs using manually set variable features
  merged_seurat <- RunPCA(merged_seurat, assay = "SCT", npcs = 50)
  
  #Perform dimensional reduction by UMAP
  merged_seurat <- RunUMAP(merged_seurat, dims = 1:15, verbose = FALSE)
  #plot UMAP
  before <- DimPlot(merged_seurat, group.by="sample_name")
  
  #RunHarmony
  harmonized_seurat <- RunHarmony(merged_seurat, 
                                  group.by.vars = c("sample_name"), 
                                  reduction = "pca", assay.use = "SCT", reduction.save = "harmony")
  
  harmonized_seurat <- RunUMAP(harmonized_seurat, 
                               reduction = "harmony", 
                               assay = "SCT", dims = 1:40)
  
  harmonized_seurat <- FindNeighbors(object = harmonized_seurat, 
                                     reduction = "harmony")
  harmonized_seurat <- FindClusters(harmonized_seurat, 
                                    resolution = c(0.2, 0.4, 0.6, 0.8, 1.0, 1.2))
  
  after <- DimPlot(harmonized_seurat, group.by="sample_name")
  pdf(sprintf("UMAP_%s.pdf",conds))
  DimPlot(merged_seurat, group.by="sample_name")
  dev.off()
  save(harmonized_seurat, file="harmonized_seurat_object.RData")
  
}
batch_correction_and_find_markers_per_cluster(list(SC2300009,SC2300011,SC2300013,SC2300010,SC2300012,SC2300014),c("DPP1","DPP1","DPP1","CPP1","CPP1","CPP1"), "DPP1_CPP1")

#load("harmonized_seurat_object.RData")