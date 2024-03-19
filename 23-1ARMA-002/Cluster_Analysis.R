setwd("/Users/shahina/Projects/23-1ARMA-002/")
#scType for annotating https://github.com/IanevskiAleksandr/sc-type?tab=readme-ov-file

library(Seurat)
library(DoubletFinder)
library(magrittr)
library(glmGamPoi)
library(ggplot2)


#Load SC2300019
patient.data <- Read10X(data.dir = "Count_files/SC2300019/filtered_feature_bc_matrix/")

# Initialize the Seurat object with the raw (non-normalized data).
seurate.obj <- CreateSeuratObject(counts = patient.data, project="canine", min.cells = 3, min.features = 200)

#calculate mitochondrial QC metrics by counting percentage of counts originating from mitochondria
#There were no mitochondrials equences available in ROS_Cfam_1.0 (Ensemble 109) according to following blog
#https://bioinformatics.stackexchange.com/questions/22062/dog-canis-lupus-familiaris-mt-gene-annotations

######################
#CELL LEVEL FILTERING
######################
#calculate mitochondrial QC metrics by counting percentage of counts originating from mitochondria
seurate.obj[["percent.mt"]] <- PercentageFeatureSet(seurate.obj, pattern = "^MT")

# Visualize QC metrics as a violin plot
VlnPlot(seurate.obj, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)

## FeatureScatter is typically used to visualize feature-feature relationships
plot1 <- FeatureScatter(seurate.obj, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
plot2 <- FeatureScatter(seurate.obj, feature1 = "nCount_RNA", feature2 = "percent.mt")

plot2 + plot1

#filter cell after viewing plot1
filtered_seurat <- subset(seurate.obj, subset = nFeature_RNA > 200 & nFeature_RNA < 5000 & percent.mt < 5)

######################
#GENE LEVEL FILTERING
######################
# Extract counts
#counts <- GetAssayData(object = filtered_seurat, slot = "counts")
counts <- GetAssayData(object = filtered_seurat, layer = "counts")

# Output a logical matrix specifying for each gene on whether or not there are more than zero counts per cell
nonzero <- counts > 0

# Sums all TRUE values and returns TRUE if more than 10 TRUE values per gene
keep_genes <- Matrix::rowSums(nonzero) >= 10

# Only keeping those genes expressed in more than 10 cells
filtered_counts <- counts[keep_genes, ]

# Reassign to filtered Seurat object
seuratobject <- CreateSeuratObject(filtered_counts, meta.data = filtered_seurat@meta.data)

seuratobject <- SCTransform(object=seuratobject,  vars.to.regress = "percent.mt")

#Perform dimensionality reduction by PCA
seuratobject <- RunPCA(seuratobject, verbose = FALSE)

# Examine and visualize PCA results a few different ways
print(seuratobject[["pca"]], dims = 1:5, nfeatures = 5)

VizDimLoadings(seuratobject, dims = 1:2, reduction = "pca")

#allows for easy exploration of the primary sources of heterogeneity in a dataset, and can be useful 
#When trying to decide which PCs to include for further downstream analyses
DimHeatmap(seuratobject, dims = 1:15, cells = 500, balanced = TRUE)


#we can observe an ‘elbow’ around PC14-15, suggesting that the majority of true signal is captured in the first 15 PCs.
ElbowPlot(seuratobject)

#Cluster the cells
seuratobject <- FindNeighbors(seuratobject, dims = 1:15, verbose = FALSE)
seuratobject <- FindClusters(seuratobject, verbose = FALSE)

#Perform dimensionality reduction by UMAP
seuratobject <- RunUMAP(seuratobject, dims = 1:15, verbose = FALSE)
#plot UMAP
DimPlot(seuratobject, label = TRUE)

#save(seuratobject, file="seurat_object_SC2300019.RData")
#load("seurat_object_SC2300019.RData")

#DoubletFinder
#https://rpubs.com/kenneditodd/doublet_finder_example
# pK Identification (no ground-truth) ------------------------------------------
sweep.res.list <- paramSweep(seuratobject, PCs = 1:15, sct = TRUE)
save(sweep.res.list, file="sweep.res_SC2300019.RData")
#load("sweep.res_SC2300019.RData")
sweep.stats <- summarizeSweep(sweep.res.list, GT = FALSE)
bcmvn <- find.pK(sweep.stats)
pK <- bcmvn$pK[which.max(bcmvn$BCmetric)] %>% as.character() %>% as.numeric()

#ggplot(bcmvn, aes(pK, BCmetric, group=1)) + geom_point() + geom_line()

# Homotypic Doublet Proportion Estimate ----------------------------------------
annotations <- seuratobject@meta.data$seurat_clusters
homotypic.prop <- modelHomotypic(annotations)
#6.1% was selected based on number of cells recovered which in this sample case is 8921
nExp_poi <- round(0.061*nrow(seuratobject@meta.data))  ## Assuming 6.1% doublet formation rate - tailor for your dataset
nExp_poi.adj <- round(nExp_poi*(1-homotypic.prop))

## Run DoubletFinder with varying classification stringencies ------------------
#seuratobject <- doubletFinder(seuratobject, PCs = 1:10, pN = 0.25, pK = pK, nExp = nExp_poi, reuse.pANN = FALSE, sct = TRUE)
seuratobject <- doubletFinder(seuratobject, PCs = 1:15, pN = 0.25, pK = pK, nExp = nExp_poi.adj, reuse.pANN = FALSE, sct = TRUE)

#Visualize Doublets
DimPlot(seuratobject, reduction = "umap",  group.by = 'DF.classifications_0.25_0.11_494')
DimPlot(seuratobject, reduction = 'umap', split.by = "DF.classifications_0.25_0.11_494")
#Number of singlets and doublets
table(seuratobject@meta.data[,10])

#Select Singlets 
seuratobject <- subset(seuratobject, subset = DF.classifications_0.25_0.11_494 == "Singlet")

DimPlot(seuratobject, reduction = 'umap', label = TRUE)

#Cluster Annotation using SC-TYPE
# load libraries
lapply(c("dplyr","Seurat","HGNChelper","ggraph","scater"), library, character.only = T)

# load gene set preparation function
source("https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/R/gene_sets_prepare.R")
# load cell type annotation function
source("https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/R/sctype_score_.R")

# DB file
db_ = "https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/ScTypeDB_full.xlsx";
tissue = c("Muscle") # e.g. Immune system,Pancreas,Liver,Eye,Kidney,Brain,Lung,Adrenal,Heart,Intestine,Muscle,Placenta,Spleen,Stomach,Thymus 

# prepare gene sets
gs_list = gene_sets_prepare(db_, tissue)

# get cell-type by cell matrix
es.max = sctype_score(scRNAseqData = seuratobject[["SCT"]]@scale.data, scaled = TRUE, 
                      gs = gs_list$gs_positive, gs2 = gs_list$gs_negative) 

# merge by cluster
cL_resutls = do.call("rbind", lapply(unique(seuratobject@meta.data$seurat_clusters), function(cl){
  es.max.cl = sort(rowSums(es.max[ ,rownames(seuratobject@meta.data[seuratobject@meta.data$seurat_clusters==cl, ])]), decreasing = !0)
  head(data.frame(cluster = cl, type = names(es.max.cl), scores = es.max.cl, ncells = sum(seuratobject@meta.data$seurat_clusters==cl)), 10)
}))
sctype_scores = cL_resutls %>% group_by(cluster) %>% top_n(n = 1, wt = scores)  

# set low-confident (low ScType score) clusters to "unknown"
sctype_scores$type[as.numeric(as.character(sctype_scores$scores)) < sctype_scores$ncells/4] = "Unknown"
print(sctype_scores[,1:3])

#overlay the identified cell types on UMAP plot
seuratobject@meta.data$customclassif = ""
for(j in unique(sctype_scores$cluster)){
  cl_type = sctype_scores[sctype_scores$cluster==j,]; 
  seuratobject@meta.data$customclassif[seuratobject@meta.data$seurat_clusters == j] = as.character(cl_type$type[1])
}

pdf("Cluster_Annotation/Cluster_annotation_SC2300019.pdf", width=10, height=10)
DimPlot(seuratobject, reduction = "umap", label = TRUE, repel = TRUE, group.by = 'customclassif')
dev.off()

#source("https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/R/auto_detect_tissue_type.R")
#db_ = "https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/ScTypeDB_full.xlsx";

# guess a tissue type
#tissue_guess = auto_detect_tissue_type(path_to_db_file = db_, seuratObject = seuratobject, scaled = TRUE, assay = "SCT")  # if saled = TRUE, make sure the data is scaled, as seuratObject[[assay]]@scale.data is used. If you just created a Seurat object, without any scaling and normalization, set scaled = FALSE, seuratObject[[assay]]@counts will be used         

#number of cell in each cluster
cluster_table <- table(seuratobject@meta.data$seurat_clusters)
percentage_table <- prop.table(cluster_table) * 100

############################################################################################################################

#Load SC2300020
patient.data <- Read10X(data.dir = "Count_files/SC2300020/filtered_feature_bc_matrix/")

# Initialize the Seurat object with the raw (non-normalized data).
seurate.obj <- CreateSeuratObject(counts = patient.data, project="canine", min.cells = 3, min.features = 200)


######################
#CELL LEVEL FILTERING
######################
#calculate mitochondrial QC metrics by counting percentage of counts originating from mitochondria
seurate.obj[["percent.mt"]] <- PercentageFeatureSet(seurate.obj, pattern = "^MT")

# Visualize QC metrics as a violin plot
VlnPlot(seurate.obj, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)

## FeatureScatter is typically used to visualize feature-feature relationships
plot1 <- FeatureScatter(seurate.obj, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
plot2 <- FeatureScatter(seurate.obj, feature1 = "nCount_RNA", feature2 = "percent.mt")

plot2 + plot1

#filter cell after viewing plot1
filtered_seurat <- subset(seurate.obj, subset = nFeature_RNA > 200 & nFeature_RNA < 3500 & percent.mt < 5)

######################
#GENE LEVEL FILTERING
######################
# Extract counts
#counts <- GetAssayData(object = filtered_seurat, slot = "counts")
counts <- GetAssayData(object = filtered_seurat, layer = "counts")

# Output a logical matrix specifying for each gene on whether or not there are more than zero counts per cell
nonzero <- counts > 0

# Sums all TRUE values and returns TRUE if more than 10 TRUE values per gene
keep_genes <- Matrix::rowSums(nonzero) >= 10

# Only keeping those genes expressed in more than 10 cells
filtered_counts <- counts[keep_genes, ]

# Reassign to filtered Seurat object
seuratobject <- CreateSeuratObject(filtered_counts, meta.data = filtered_seurat@meta.data)

seuratobject <- SCTransform(object=seuratobject,  vars.to.regress = "percent.mt")

#Perform dimensionality reduction by PCA
seuratobject <- RunPCA(seuratobject, verbose = FALSE)

# Examine and visualize PCA results a few different ways
#print(seuratobject[["pca"]], dims = 1:5, nfeatures = 5)

VizDimLoadings(seuratobject, dims = 1:2, reduction = "pca")

#allows for easy exploration of the primary sources of heterogeneity in a dataset, and can be useful 
#When trying to decide which PCs to include for further downstream analyses
DimHeatmap(seuratobject, dims = 1:15, cells = 500, balanced = TRUE)


#we can observe an ‘elbow’ around PC14-15, suggesting that the majority of true signal is captured in the first 15 PCs.
ElbowPlot(seuratobject)

#Cluster the cells
seuratobject <- FindNeighbors(seuratobject, dims = 1:15, verbose = FALSE)
seuratobject <- FindClusters(seuratobject, verbose = FALSE)

#Perform dimensionality reduction by UMAP
seuratobject <- RunUMAP(seuratobject, dims = 1:15, verbose = FALSE)
#plot UMAP
DimPlot(seuratobject, label = TRUE)

save(seuratobject, file="seurat_object_SC2300020.RData")
#load("seurat_object_SC2300020.RData")

#DoubletFinder
#https://rpubs.com/kenneditodd/doublet_finder_example
# pK Identification (no ground-truth) ------------------------------------------
sweep.res.list <- paramSweep(seuratobject, PCs = 1:15, sct = TRUE)
#save(sweep.res.list, file="sweep.res.SC2300020.RData")
#load("sweep.res.SC2300020.RData")
sweep.stats <- summarizeSweep(sweep.res.list, GT = FALSE)
bcmvn <- find.pK(sweep.stats)
pK <- bcmvn$pK[which.max(bcmvn$BCmetric)] %>% as.character() %>% as.numeric()

#ggplot(bcmvn, aes(pK, BCmetric, group=1)) + geom_point() + geom_line()

# Homotypic Doublet Proportion Estimate ----------------------------------------
annotations <- seuratobject@meta.data$seurat_clusters
homotypic.prop <- modelHomotypic(annotations)
#4.6% was selected based on number of cells recovered which in this sample case is 6,153
nExp_poi <- round(0.046*nrow(seuratobject@meta.data))  ## Assuming 4.6% doublet formation rate - tailor for your dataset
nExp_poi.adj <- round(nExp_poi*(1-homotypic.prop))

## Run DoubletFinder with varying classification stringencies ------------------
#seuratobject <- doubletFinder(seuratobject, PCs = 1:10, pN = 0.25, pK = pK, nExp = nExp_poi, reuse.pANN = FALSE, sct = TRUE)
seuratobject <- doubletFinder(seuratobject, PCs = 1:10, pN = 0.25, pK = pK, nExp = nExp_poi.adj, reuse.pANN = FALSE, sct = TRUE)

#Visualize Doublets
#DimPlot(seuratobject, reduction = "umap",  group.by = names(seuratobject@meta.data$DF.classifications_0.25_0.1_245))
DimPlot(seuratobject, reduction = 'umap', split.by = names(seuratobject@meta.data$DF.classifications_0.25_0.1_245))
#Number of singlets and doublets
table(seuratobject@meta.data[10])

#Select Singlets 
seuratobject <- subset(seuratobject, subset = DF.classifications_0.25_0.1_245 == "Singlet")

DimPlot(seuratobject, reduction = 'umap', label = TRUE)

#Cluster Annotation using SC-TYPE
# load libraries
lapply(c("dplyr","Seurat","HGNChelper","ggraph","scater"), library, character.only = T)

# load gene set preparation function
source("https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/R/gene_sets_prepare.R")
# load cell type annotation function
source("https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/R/sctype_score_.R")

# DB file
db_ = "https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/ScTypeDB_full.xlsx";
tissue = c("Muscle") # e.g. Immune system,Pancreas,Liver,Eye,Kidney,Brain,Lung,Adrenal,Heart,Intestine,Muscle,Placenta,Spleen,Stomach,Thymus 

# prepare gene sets
gs_list = gene_sets_prepare(db_, tissue)

# get cell-type by cell matrix
es.max = sctype_score(scRNAseqData = seuratobject[["SCT"]]@scale.data, scaled = TRUE, 
                      gs = gs_list$gs_positive, gs2 = gs_list$gs_negative) 

# merge by cluster
cL_resutls = do.call("rbind", lapply(unique(seuratobject@meta.data$seurat_clusters), function(cl){
  es.max.cl = sort(rowSums(es.max[ ,rownames(seuratobject@meta.data[seuratobject@meta.data$seurat_clusters==cl, ])]), decreasing = !0)
  head(data.frame(cluster = cl, type = names(es.max.cl), scores = es.max.cl, ncells = sum(seuratobject@meta.data$seurat_clusters==cl)), 10)
}))
sctype_scores = cL_resutls %>% group_by(cluster) %>% top_n(n = 1, wt = scores)  

# set low-confident (low ScType score) clusters to "unknown"
sctype_scores$type[as.numeric(as.character(sctype_scores$scores)) < sctype_scores$ncells/4] = "Unknown"
print(sctype_scores[,1:3])

#overlay the identified cell types on UMAP plot
seuratobject@meta.data$customclassif = ""
for(j in unique(sctype_scores$cluster)){
  cl_type = sctype_scores[sctype_scores$cluster==j,]; 
  seuratobject@meta.data$customclassif[seuratobject@meta.data$seurat_clusters == j] = as.character(cl_type$type[1])
}

pdf("Cluster_Annotation/Cluster_annotation_SC2300020.pdf", width=10, height=10)
DimPlot(seuratobject, reduction = "umap", label = TRUE, repel = TRUE, group.by = 'customclassif')
dev.off()

source("https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/R/auto_detect_tissue_type.R")
db_ = "https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/ScTypeDB_full.xlsx";

# guess a tissue type
tissue_guess = auto_detect_tissue_type(path_to_db_file = db_, seuratObject = seuratobject, scaled = TRUE, assay = "SCT")  # if saled = TRUE, make sure the data is scaled, as seuratObject[[assay]]@scale.data is used. If you just created a Seurat object, without any scaling and normalization, set scaled = FALSE, seuratObject[[assay]]@counts will be used         


############################################################################################################################

#Load SC2300021
patient.data <- Read10X(data.dir = "Count_files/SC2300021/filtered_feature_bc_matrix/")

# Initialize the Seurat object with the raw (non-normalized data).
seurate.obj <- CreateSeuratObject(counts = patient.data, project="canine", min.cells = 3, min.features = 200)


######################
#CELL LEVEL FILTERING
######################
#calculate mitochondrial QC metrics by counting percentage of counts originating from mitochondria
seurate.obj[["percent.mt"]] <- PercentageFeatureSet(seurate.obj, pattern = "^MT")

# Visualize QC metrics as a violin plot
VlnPlot(seurate.obj, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)

## FeatureScatter is typically used to visualize feature-feature relationships
plot1 <- FeatureScatter(seurate.obj, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
plot2 <- FeatureScatter(seurate.obj, feature1 = "nCount_RNA", feature2 = "percent.mt")

plot2 + plot1

#filter cell after viewing plot1
filtered_seurat <- subset(seurate.obj, subset = nFeature_RNA > 200 & nFeature_RNA < 3200 & percent.mt < 5)

######################
#GENE LEVEL FILTERING
######################
# Extract counts
counts <- GetAssayData(object = filtered_seurat, layer = "counts")

# Output a logical matrix specifying for each gene on whether or not there are more than zero counts per cell
nonzero <- counts > 0

# Sums all TRUE values and returns TRUE if more than 10 TRUE values per gene
keep_genes <- Matrix::rowSums(nonzero) >= 10

# Only keeping those genes expressed in more than 10 cells
filtered_counts <- counts[keep_genes, ]

# Reassign to filtered Seurat object
seuratobject <- CreateSeuratObject(filtered_counts, meta.data = filtered_seurat@meta.data)

seuratobject <- SCTransform(object=seuratobject,  vars.to.regress = "percent.mt")

#Perform dimensionality reduction by PCA
seuratobject <- RunPCA(seuratobject, verbose = FALSE)

# Examine and visualize PCA results a few different ways
print(seuratobject[["pca"]], dims = 1:5, nfeatures = 5)

VizDimLoadings(seuratobject, dims = 1:2, reduction = "pca")

#allows for easy exploration of the primary sources of heterogeneity in a dataset, and can be useful 
#When trying to decide which PCs to include for further downstream analyses
DimHeatmap(seuratobject, dims = 1:15, cells = 500, balanced = TRUE)


#we can observe an ‘elbow’ around PC14-15, suggesting that the majority of true signal is captured in the first 15 PCs.
ElbowPlot(seuratobject)

#Cluster the cells
seuratobject <- FindNeighbors(seuratobject, dims = 1:15, verbose = FALSE)
seuratobject <- FindClusters(seuratobject, verbose = FALSE)

#Perform dimensionality reduction by UMAP
seuratobject <- RunUMAP(seuratobject, dims = 1:15, verbose = FALSE)
#plot UMAP
DimPlot(seuratobject, label = TRUE)

save(seuratobject, file="seurat_object_SC2300021.RData")
#load("seurat_object_SC2300021.RData")

#DoubletFinder
#https://rpubs.com/kenneditodd/doublet_finder_example
# pK Identification (no ground-truth) ------------------------------------------
sweep.res.list <- paramSweep(seuratobject, PCs = 1:15, sct = TRUE)
save(sweep.res.list, file="sweep.res.object_SC2300021.RData")
#load("sweep.res.object_SC2300021.RData")
sweep.stats <- summarizeSweep(sweep.res.list, GT = FALSE)
bcmvn <- find.pK(sweep.stats)
pK <- bcmvn$pK[which.max(bcmvn$BCmetric)] %>% as.character() %>% as.numeric()

#ggplot(bcmvn, aes(pK, BCmetric, group=1)) + geom_point() + geom_line()

# Homotypic Doublet Proportion Estimate ----------------------------------------
annotations <- seuratobject@meta.data$seurat_clusters
homotypic.prop <- modelHomotypic(annotations)
#6.1% was selected based on number of cells recovered which in this sample case is 8829
nExp_poi <- round(0.061*nrow(seuratobject@meta.data))  ## Assuming 6.1% doublet formation rate - tailor for your dataset
nExp_poi.adj <- round(nExp_poi*(1-homotypic.prop))

## Run DoubletFinder with varying classification stringencies ------------------
#seuratobject <- doubletFinder(seuratobject, PCs = 1:10, pN = 0.25, pK = pK, nExp = nExp_poi, reuse.pANN = FALSE, sct = TRUE)
seuratobject <- doubletFinder(seuratobject, PCs = 1:15, pN = 0.25, pK = pK, nExp = nExp_poi.adj, reuse.pANN = FALSE, sct = TRUE)

#Visualize Doublets
DimPlot(seuratobject, reduction = "umap",  group.by = 'DF.classifications_0.25_0.21_461')
DimPlot(seuratobject, reduction = 'umap', split.by = "DF.classifications_0.25_0.21_461")
#Number of singlets and doublets
table(seuratobject@meta.data$DF.classifications_0.25_0.21_461)

#Select Singlets 
seuratobject <- subset(seuratobject, subset = DF.classifications_0.25_0.21_461 == "Singlet")

DimPlot(seuratobject, reduction = 'umap', label = TRUE)

#Cluster Annotation using SC-TYPE
# load libraries
lapply(c("dplyr","Seurat","HGNChelper","ggraph","scater"), library, character.only = T)

# load gene set preparation function
source("https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/R/gene_sets_prepare.R")
# load cell type annotation function
source("https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/R/sctype_score_.R")

# DB file
db_ = "https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/ScTypeDB_full.xlsx";
tissue = c("Muscle") # e.g. Immune system,Pancreas,Liver,Eye,Kidney,Brain,Lung,Adrenal,Heart,Intestine,Muscle,Placenta,Spleen,Stomach,Thymus 

# prepare gene sets
gs_list = gene_sets_prepare(db_, tissue)

# get cell-type by cell matrix
es.max = sctype_score(scRNAseqData = seuratobject[["SCT"]]@scale.data, scaled = TRUE, 
                      gs = gs_list$gs_positive, gs2 = gs_list$gs_negative) 

# merge by cluster
cL_resutls = do.call("rbind", lapply(unique(seuratobject@meta.data$seurat_clusters), function(cl){
  es.max.cl = sort(rowSums(es.max[ ,rownames(seuratobject@meta.data[seuratobject@meta.data$seurat_clusters==cl, ])]), decreasing = !0)
  head(data.frame(cluster = cl, type = names(es.max.cl), scores = es.max.cl, ncells = sum(seuratobject@meta.data$seurat_clusters==cl)), 10)
}))
sctype_scores = cL_resutls %>% group_by(cluster) %>% top_n(n = 1, wt = scores)  

# set low-confident (low ScType score) clusters to "unknown"
sctype_scores$type[as.numeric(as.character(sctype_scores$scores)) < sctype_scores$ncells/4] = "Unknown"
print(sctype_scores[,1:3])

#overlay the identified cell types on UMAP plot
seuratobject@meta.data$customclassif = ""
for(j in unique(sctype_scores$cluster)){
  cl_type = sctype_scores[sctype_scores$cluster==j,]; 
  seuratobject@meta.data$customclassif[seuratobject@meta.data$seurat_clusters == j] = as.character(cl_type$type[1])
}
pdf("Cluster_Annotation/Cluster_annotation_SC2300021.pdf", width=10, height=10)
DimPlot(seuratobject, reduction = "umap", label = TRUE, repel = TRUE, group.by = 'customclassif')
dev.off()

#source("https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/R/auto_detect_tissue_type.R")
#db_ = "https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/ScTypeDB_full.xlsx";

# guess a tissue type
#tissue_guess = auto_detect_tissue_type(path_to_db_file = db_, seuratObject = seuratobject, scaled = TRUE, assay = "SCT")  # if saled = TRUE, make sure the data is scaled, as seuratObject[[assay]]@scale.data is used. If you just created a Seurat object, without any scaling and normalization, set scaled = FALSE, seuratObject[[assay]]@counts will be used         



###################################################################################################################################
#Load SC2300022
patient.data <- Read10X(data.dir = "Count_files/SC2300022/filtered_feature_bc_matrix/")

# Initialize the Seurat object with the raw (non-normalized data).
seurate.obj <- CreateSeuratObject(counts = patient.data, project="canine", min.cells = 3, min.features = 200)


######################
#CELL LEVEL FILTERING
######################
#calculate mitochondrial QC metrics by counting percentage of counts originating from mitochondria
seurate.obj[["percent.mt"]] <- PercentageFeatureSet(seurate.obj, pattern = "^MT")

# Visualize QC metrics as a violin plot
VlnPlot(seurate.obj, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)

## FeatureScatter is typically used to visualize feature-feature relationships
plot1 <- FeatureScatter(seurate.obj, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
plot2 <- FeatureScatter(seurate.obj, feature1 = "nCount_RNA", feature2 = "percent.mt")

plot2 + plot1

#filter cell after viewing plot1
filtered_seurat <- subset(seurate.obj, subset = nFeature_RNA > 200 & nFeature_RNA < 5300 & percent.mt < 5)

######################
#GENE LEVEL FILTERING
######################
# Extract counts
counts <- GetAssayData(object = filtered_seurat, layer = "counts")

# Output a logical matrix specifying for each gene on whether or not there are more than zero counts per cell
nonzero <- counts > 0

# Sums all TRUE values and returns TRUE if more than 10 TRUE values per gene
keep_genes <- Matrix::rowSums(nonzero) >= 10

# Only keeping those genes expressed in more than 10 cells
filtered_counts <- counts[keep_genes, ]

# Reassign to filtered Seurat object
seuratobject <- CreateSeuratObject(filtered_counts, meta.data = filtered_seurat@meta.data)

seuratobject <- SCTransform(object=seuratobject,  vars.to.regress = "percent.mt")

#Perform dimensionality reduction by PCA
seuratobject <- RunPCA(seuratobject, verbose = FALSE)

# Examine and visualize PCA results a few different ways
print(seuratobject[["pca"]], dims = 1:5, nfeatures = 5)

VizDimLoadings(seuratobject, dims = 1:2, reduction = "pca")

#allows for easy exploration of the primary sources of heterogeneity in a dataset, and can be useful 
#When trying to decide which PCs to include for further downstream analyses
DimHeatmap(seuratobject, dims = 1:15, cells = 500, balanced = TRUE)


#we can observe an ‘elbow’ around PC14-15, suggesting that the majority of true signal is captured in the first 15 PCs.
ElbowPlot(seuratobject)

#Cluster the cells
seuratobject <- FindNeighbors(seuratobject, dims = 1:15, verbose = FALSE)
seuratobject <- FindClusters(seuratobject, verbose = FALSE)

#Perform dimensionality reduction by UMAP
seuratobject <- RunUMAP(seuratobject, dims = 1:15, verbose = FALSE)
#plot UMAP
DimPlot(seuratobject, label = TRUE)

#save(seuratobject, file="seurat_object_SC2300022.RData")
#load("seurat_object_SC2300022.RData")

#DoubletFinder
#https://rpubs.com/kenneditodd/doublet_finder_example
# pK Identification (no ground-truth) ------------------------------------------
sweep.res.list <- paramSweep(seuratobject, PCs = 1:15, sct = TRUE)
#save(sweep.res.list, file="sweep.res.SC2300022.RData")
#load("sweep.res.SC2300022.RData")
sweep.stats <- summarizeSweep(sweep.res.list, GT = FALSE)
bcmvn <- find.pK(sweep.stats)
pK <- bcmvn$pK[which.max(bcmvn$BCmetric)] %>% as.character() %>% as.numeric()

#ggplot(bcmvn, aes(pK, BCmetric, group=1)) + geom_point() + geom_line()

# Homotypic Doublet Proportion Estimate ----------------------------------------
annotations <- seuratobject@meta.data$seurat_clusters
homotypic.prop <- modelHomotypic(annotations)
#6.1% was selected based on number of cells recovered which in this sample case is 8602
nExp_poi <- round(0.061*nrow(seuratobject@meta.data))  ## Assuming 6.1% doublet formation rate - tailor for your dataset
nExp_poi.adj <- round(nExp_poi*(1-homotypic.prop))

## Run DoubletFinder with varying classification stringencies ------------------
#seuratobject <- doubletFinder(seuratobject, PCs = 1:10, pN = 0.25, pK = pK, nExp = nExp_poi, reuse.pANN = FALSE, sct = TRUE)
seuratobject <- doubletFinder(seuratobject, PCs = 1:15, pN = 0.25, pK = pK, nExp = nExp_poi.adj, reuse.pANN = FALSE, sct = TRUE)

#Visualize Doublets
DimPlot(seuratobject, reduction = "umap",  group.by = 'DF.classifications_0.25_0.14_379')
DimPlot(seuratobject, reduction = 'umap', split.by = "DF.classifications_0.25_0.14_379")
#Number of singlets and doublets
table(seuratobject@meta.data$DF.classifications_0.25_0.14_379)

#Select Singlets 
seuratobject <- subset(seuratobject, subset = DF.classifications_0.25_0.14_379 == "Singlet")

DimPlot(seuratobject, reduction = 'umap', label = TRUE)

#Cluster Annotation using SC-TYPE
# load libraries
lapply(c("dplyr","Seurat","HGNChelper","ggraph","scater"), library, character.only = T)

# load gene set preparation function
source("https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/R/gene_sets_prepare.R")
# load cell type annotation function
source("https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/R/sctype_score_.R")

# DB file
db_ = "https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/ScTypeDB_full.xlsx";
tissue = c("Muscle") # e.g. Immune system,Pancreas,Liver,Eye,Kidney,Brain,Lung,Adrenal,Heart,Intestine,Muscle,Placenta,Spleen,Stomach,Thymus 

# prepare gene sets
gs_list = gene_sets_prepare(db_, tissue)

# get cell-type by cell matrix
es.max = sctype_score(scRNAseqData = seuratobject[["SCT"]]@scale.data, scaled = TRUE, 
                      gs = gs_list$gs_positive, gs2 = gs_list$gs_negative) 

# merge by cluster
cL_resutls = do.call("rbind", lapply(unique(seuratobject@meta.data$seurat_clusters), function(cl){
  es.max.cl = sort(rowSums(es.max[ ,rownames(seuratobject@meta.data[seuratobject@meta.data$seurat_clusters==cl, ])]), decreasing = !0)
  head(data.frame(cluster = cl, type = names(es.max.cl), scores = es.max.cl, ncells = sum(seuratobject@meta.data$seurat_clusters==cl)), 10)
}))
sctype_scores = cL_resutls %>% group_by(cluster) %>% top_n(n = 1, wt = scores)  

# set low-confident (low ScType score) clusters to "unknown"
sctype_scores$type[as.numeric(as.character(sctype_scores$scores)) < sctype_scores$ncells/4] = "Unknown"
print(sctype_scores[,1:3])

#overlay the identified cell types on UMAP plot
seuratobject@meta.data$customclassif = ""
for(j in unique(sctype_scores$cluster)){
  cl_type = sctype_scores[sctype_scores$cluster==j,]; 
  seuratobject@meta.data$customclassif[seuratobject@meta.data$seurat_clusters == j] = as.character(cl_type$type[1])
}

pdf("Cluster_Annotation/Cluster_annotation_SC2300022.pdf", width=10, height=10)
DimPlot(seuratobject, reduction = "umap", label = TRUE, repel = TRUE, group.by = 'customclassif')
dev.off()

#source("https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/R/auto_detect_tissue_type.R")
#db_ = "https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/ScTypeDB_full.xlsx";

# guess a tissue type
#tissue_guess = auto_detect_tissue_type(path_to_db_file = db_, seuratObject = seuratobject, scaled = TRUE, assay = "SCT")  # if saled = TRUE, make sure the data is scaled, as seuratObject[[assay]]@scale.data is used. If you just created a Seurat object, without any scaling and normalization, set scaled = FALSE, seuratObject[[assay]]@counts will be used         



