setwd("/Users/shahina/Projects/23-1ANFA-001/")

library(Seurat)
library(DoubletFinder)
library(magrittr)
library(glmGamPoi)
library(ggplot2)


#Load SC2300009
patient.data <- Read10X(data.dir = "count_files/SC2300009/filtered_feature_bc_matrix/")

# Initialize the Seurat object with the raw (non-normalized data).
seurate.obj <- CreateSeuratObject(counts = patient.data, project="bovine", min.cells = 3, min.features = 200)

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
filtered_seurat <- subset(seurate.obj, subset = nFeature_RNA > 200 & nFeature_RNA < 4300 & percent.mt < 4)

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

#DoubletFinder
#https://rpubs.com/kenneditodd/doublet_finder_example
# pK Identification (no ground-truth) ------------------------------------------
sweep.res.list <- paramSweep(seuratobject, PCs = 1:15, sct = TRUE)
sweep.stats <- summarizeSweep(sweep.res.list, GT = FALSE)
bcmvn <- find.pK(sweep.stats)
pK <- bcmvn$pK[which.max(bcmvn$BCmetric)] %>% as.character() %>% as.numeric()

#ggplot(bcmvn, aes(pK, BCmetric, group=1)) + geom_point() + geom_line()

# Homotypic Doublet Proportion Estimate ----------------------------------------
annotations <- seuratobject@meta.data$seurat_clusters
homotypic.prop <- modelHomotypic(annotations)
#4.6% was selected based on number of cells recovered which in this sample case is 6273
nExp_poi <- round(0.046*nrow(seuratobject@meta.data))  ## Assuming 4.6% doublet formation rate
nExp_poi.adj <- round(nExp_poi*(1-homotypic.prop))

## Run DoubletFinder with varying classification stringencies ------------------
#seuratobject <- doubletFinder(seuratobject, PCs = 1:10, pN = 0.25, pK = pK, nExp = nExp_poi, reuse.pANN = FALSE, sct = TRUE)
seuratobject <- doubletFinder(seuratobject, PCs = 1:15, pN = 0.25, pK = pK, nExp = nExp_poi.adj, reuse.pANN = FALSE, sct = TRUE)

#Visualize Doublets
DimPlot(seuratobject, reduction = "umap",  group.by = 'DF.classifications_0.25_0.06_268')
DimPlot(seuratobject, reduction = 'umap', split.by = "DF.classifications_0.25_0.06_268")
#Number of singlets and doublets
table(seuratobject@meta.data[,10])

#Select Singlets 
seuratobject <- subset(seuratobject, subset = DF.classifications_0.25_0.06_268 == "Singlet")

DimPlot(seuratobject, reduction = 'umap', label = TRUE)

save(seuratobject, file="seuratobject_SC2300009.RData")


############################################################################################################################

#Load SC2300010
patient.data <- Read10X(data.dir = "count_files/SC2300010/filtered_feature_bc_matrix/")

# Initialize the Seurat object with the raw (non-normalized data).
seurate.obj <- CreateSeuratObject(counts = patient.data, project="bovine", min.cells = 3, min.features = 200)

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
filtered_seurat <- subset(seurate.obj, subset = nFeature_RNA > 200 & nFeature_RNA < 4500 & percent.mt < 4)

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


#DoubletFinder
#https://rpubs.com/kenneditodd/doublet_finder_example
# pK Identification (no ground-truth) ------------------------------------------
sweep.res.list <- paramSweep(seuratobject, PCs = 1:15, sct = TRUE)
sweep.stats <- summarizeSweep(sweep.res.list, GT = FALSE)
bcmvn <- find.pK(sweep.stats)
pK <- bcmvn$pK[which.max(bcmvn$BCmetric)] %>% as.character() %>% as.numeric()

#ggplot(bcmvn, aes(pK, BCmetric, group=1)) + geom_point() + geom_line()

# Homotypic Doublet Proportion Estimate ----------------------------------------
annotations <- seuratobject@meta.data$seurat_clusters
homotypic.prop <- modelHomotypic(annotations)
#4.6% was selected based on number of cells recovered which in this sample case is 6222
nExp_poi <- round(0.046*nrow(seuratobject@meta.data))  ## Assuming 4.6% doublet formation rate
nExp_poi.adj <- round(nExp_poi*(1-homotypic.prop))

## Run DoubletFinder with varying classification stringencies ------------------
#seuratobject <- doubletFinder(seuratobject, PCs = 1:10, pN = 0.25, pK = pK, nExp = nExp_poi, reuse.pANN = FALSE, sct = TRUE)
seuratobject <- doubletFinder(seuratobject, PCs = 1:15, pN = 0.25, pK = pK, nExp = nExp_poi.adj, reuse.pANN = FALSE, sct = TRUE)

#Visualize Doublets
#DimPlot(seuratobject, reduction = "umap",  group.by = names(seuratobject@meta.data$DF.classifications_0.25_0.1_245))
DimPlot(seuratobject, reduction = 'umap', split.by = names(seuratobject@meta.data$DF.classifications_0.25_0.05_268))
#Number of singlets and doublets
table(seuratobject@meta.data[10])

#Select Singlets 
seuratobject <- subset(seuratobject, subset = DF.classifications_0.25_0.05_268 == "Singlet")

DimPlot(seuratobject, reduction = 'umap', label = TRUE)

save(seuratobject, file="seuratobject_SC2300010.RData")

############################################################################################################################
#Load SC2300011
patient.data <- Read10X(data.dir = "Count_files/SC2300011/filtered_feature_bc_matrix/")

# Initialize the Seurat object with the raw (non-normalized data).
seurate.obj <- CreateSeuratObject(counts = patient.data, project="bovine", min.cells = 3, min.features = 200)

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
filtered_seurat <- subset(seurate.obj, subset = nFeature_RNA > 200 & nFeature_RNA < 4300 & percent.mt < 4)

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

#DoubletFinder
#https://rpubs.com/kenneditodd/doublet_finder_example
# pK Identification (no ground-truth) ------------------------------------------
sweep.res.list <- paramSweep(seuratobject, PCs = 1:15, sct = TRUE)
sweep.stats <- summarizeSweep(sweep.res.list, GT = FALSE)
bcmvn <- find.pK(sweep.stats)
pK <- bcmvn$pK[which.max(bcmvn$BCmetric)] %>% as.character() %>% as.numeric()

#ggplot(bcmvn, aes(pK, BCmetric, group=1)) + geom_point() + geom_line()

# Homotypic Doublet Proportion Estimate ----------------------------------------
annotations <- seuratobject@meta.data$seurat_clusters
homotypic.prop <- modelHomotypic(annotations)
#2.3% was selected based on number of cells recovered which in this sample case is 3926
nExp_poi <- round(0.023*nrow(seuratobject@meta.data))  ## Assuming 2.3% doublet formation rate - tailor for your dataset
nExp_poi.adj <- round(nExp_poi*(1-homotypic.prop))

## Run DoubletFinder with varying classification stringencies ------------------
#seuratobject <- doubletFinder(seuratobject, PCs = 1:10, pN = 0.25, pK = pK, nExp = nExp_poi, reuse.pANN = FALSE, sct = TRUE)
seuratobject <- doubletFinder(seuratobject, PCs = 1:15, pN = 0.25, pK = pK, nExp = nExp_poi.adj, reuse.pANN = FALSE, sct = TRUE)

#Visualize Doublets
DimPlot(seuratobject, reduction = "umap",  group.by = 'DF.classifications_0.25_0.02_81')
DimPlot(seuratobject, reduction = 'umap', split.by = "DF.classifications_0.25_0.02_81")
#Number of singlets and doublets
table(seuratobject@meta.data$DF.classifications_0.25_0.02_81)

#Select Singlets 
seuratobject <- subset(seuratobject, subset = DF.classifications_0.25_0.02_81 == "Singlet")

DimPlot(seuratobject, reduction = 'umap', label = TRUE)
save(seuratobject, file="seuratobject_SC2300011.RData")

###################################################################################################################################
#Load SC2300012
patient.data <- Read10X(data.dir = "count_files/SC2300012/filtered_feature_bc_matrix/")

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
filtered_seurat <- subset(seurate.obj, subset = nFeature_RNA > 200 & nFeature_RNA < 5300 & percent.mt < 4)

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

#DoubletFinder
#https://rpubs.com/kenneditodd/doublet_finder_example
# pK Identification (no ground-truth) ------------------------------------------
sweep.res.list <- paramSweep(seuratobject, PCs = 1:15, sct = TRUE)
sweep.stats <- summarizeSweep(sweep.res.list, GT = FALSE)
bcmvn <- find.pK(sweep.stats)
pK <- bcmvn$pK[which.max(bcmvn$BCmetric)] %>% as.character() %>% as.numeric()

#ggplot(bcmvn, aes(pK, BCmetric, group=1)) + geom_point() + geom_line()

# Homotypic Doublet Proportion Estimate ----------------------------------------
annotations <- seuratobject@meta.data$seurat_clusters
homotypic.prop <- modelHomotypic(annotations)
#3.1% was selected based on number of cells recovered which in this sample case is 8602
nExp_poi <- round(0.031*nrow(seuratobject@meta.data))  ## Assuming 3.1% doublet formation rate 
nExp_poi.adj <- round(nExp_poi*(1-homotypic.prop))

## Run DoubletFinder with varying classification stringencies ------------------
#seuratobject <- doubletFinder(seuratobject, PCs = 1:10, pN = 0.25, pK = pK, nExp = nExp_poi, reuse.pANN = FALSE, sct = TRUE)
seuratobject <- doubletFinder(seuratobject, PCs = 1:15, pN = 0.25, pK = pK, nExp = nExp_poi.adj, reuse.pANN = FALSE, sct = TRUE)

#Visualize Doublets
DimPlot(seuratobject, reduction = "umap",  group.by = 'DF.classifications_0.25_0.13_140')
DimPlot(seuratobject, reduction = 'umap', split.by = "DF.classifications_0.25_0.13_140")
#Number of singlets and doublets
table(seuratobject@meta.data$DF.classifications_0.25_0.13_140)

#Select Singlets 
seuratobject <- subset(seuratobject, subset = DF.classifications_0.25_0.13_140 == "Singlet")

DimPlot(seuratobject, reduction = 'umap', label = TRUE)

save(seuratobject, file="seuratobject_SC2300012.RData")

###################################################################################################################################
#Load SC2300013
patient.data <- Read10X(data.dir = "count_files/SC2300013/filtered_feature_bc_matrix/")

# Initialize the Seurat object with the raw (non-normalized data).
seurate.obj <- CreateSeuratObject(counts = patient.data, project="bovine", min.cells = 3, min.features = 200)

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
filtered_seurat <- subset(seurate.obj, subset = nFeature_RNA > 200 & nFeature_RNA < 5300 & percent.mt < 4)

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


#DoubletFinder
#https://rpubs.com/kenneditodd/doublet_finder_example
# pK Identification (no ground-truth) ------------------------------------------
sweep.res.list <- paramSweep(seuratobject, PCs = 1:15, sct = TRUE)
sweep.stats <- summarizeSweep(sweep.res.list, GT = FALSE)
bcmvn <- find.pK(sweep.stats)
pK <- bcmvn$pK[which.max(bcmvn$BCmetric)] %>% as.character() %>% as.numeric()

#ggplot(bcmvn, aes(pK, BCmetric, group=1)) + geom_point() + geom_line()

# Homotypic Doublet Proportion Estimate ----------------------------------------
annotations <- seuratobject@meta.data$seurat_clusters
homotypic.prop <- modelHomotypic(annotations)
#3.1% was selected based on number of cells recovered which in this sample case is 4913
nExp_poi <- round(0.031*nrow(seuratobject@meta.data))  ## Assuming 3.1% doublet formation rate
nExp_poi.adj <- round(nExp_poi*(1-homotypic.prop))

## Run DoubletFinder with varying classification stringencies ------------------
#seuratobject <- doubletFinder(seuratobject, PCs = 1:10, pN = 0.25, pK = pK, nExp = nExp_poi, reuse.pANN = FALSE, sct = TRUE)
seuratobject <- doubletFinder(seuratobject, PCs = 1:15, pN = 0.25, pK = pK, nExp = nExp_poi.adj, reuse.pANN = FALSE, sct = TRUE)

#Visualize Doublets
DimPlot(seuratobject, reduction = "umap",  group.by = 'DF.classifications_0.25_0.13_140')
DimPlot(seuratobject, reduction = 'umap', split.by = "DF.classifications_0.25_0.13_140")
#Number of singlets and doublets
table(seuratobject@meta.data$DF.classifications_0.25_0.13_140)

#Select Singlets 
seuratobject <- subset(seuratobject, subset = DF.classifications_0.25_0.13_140 == "Singlet")

DimPlot(seuratobject, reduction = 'umap', label = TRUE)

save(seuratobject, file="seuratobject_SC2300013.RData")


###################################################################################################################################
#Load SC2300014
patient.data <- Read10X(data.dir = "count_files/SC2300014/filtered_feature_bc_matrix/")

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
filtered_seurat <- subset(seurate.obj, subset = nFeature_RNA > 200 & nFeature_RNA < 5300 & percent.mt < 4)

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


#DoubletFinder
#https://rpubs.com/kenneditodd/doublet_finder_example
# pK Identification (no ground-truth) ------------------------------------------
sweep.res.list <- paramSweep(seuratobject, PCs = 1:15, sct = TRUE)
sweep.stats <- summarizeSweep(sweep.res.list, GT = FALSE)
bcmvn <- find.pK(sweep.stats)
pK <- bcmvn$pK[which.max(bcmvn$BCmetric)] %>% as.character() %>% as.numeric()

#ggplot(bcmvn, aes(pK, BCmetric, group=1)) + geom_point() + geom_line()

# Homotypic Doublet Proportion Estimate ----------------------------------------
annotations <- seuratobject@meta.data$seurat_clusters
homotypic.prop <- modelHomotypic(annotations)
#3.1% was selected based on number of cells recovered which in this sample case is 4796
nExp_poi <- round(0.031*nrow(seuratobject@meta.data))  ## Assuming 3.1% doublet formation rate 
nExp_poi.adj <- round(nExp_poi*(1-homotypic.prop))

## Run DoubletFinder with varying classification stringencies ------------------
#seuratobject <- doubletFinder(seuratobject, PCs = 1:10, pN = 0.25, pK = pK, nExp = nExp_poi, reuse.pANN = FALSE, sct = TRUE)
seuratobject <- doubletFinder(seuratobject, PCs = 1:15, pN = 0.25, pK = pK, nExp = nExp_poi.adj, reuse.pANN = FALSE, sct = TRUE)

#Visualize Doublets
DimPlot(seuratobject, reduction = "umap",  group.by = 'DF.classifications_0.25_0.03_379')
DimPlot(seuratobject, reduction = 'umap', split.by = "DF.classifications_0.25_0.03_379")
#Number of singlets and doublets
table(seuratobject@meta.data$DF.classifications_0.25_0.03_379)

#Select Singlets 
seuratobject <- subset(seuratobject, subset = DF.classifications_0.25_0.03_379 == "Singlet")

DimPlot(seuratobject, reduction = 'umap', label = TRUE)

save(seuratobject, file="seuratobject_SC2300014.RData")


###################################################################################################################################
#Load SC2300015
patient.data <- Read10X(data.dir = "count_files/SC2300015/filtered_feature_bc_matrix/")

# Initialize the Seurat object with the raw (non-normalized data).
seurate.obj <- CreateSeuratObject(counts = patient.data, project="bovine", min.cells = 3, min.features = 200)

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
filtered_seurat <- subset(seurate.obj, subset = nFeature_RNA > 200 & nFeature_RNA < 4500 & percent.mt < 4)

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


#DoubletFinder
#https://rpubs.com/kenneditodd/doublet_finder_example
# pK Identification (no ground-truth) ------------------------------------------
sweep.res.list <- paramSweep(seuratobject, PCs = 1:15, sct = TRUE)
sweep.stats <- summarizeSweep(sweep.res.list, GT = FALSE)
bcmvn <- find.pK(sweep.stats)
pK <- bcmvn$pK[which.max(bcmvn$BCmetric)] %>% as.character() %>% as.numeric()

#ggplot(bcmvn, aes(pK, BCmetric, group=1)) + geom_point() + geom_line()

# Homotypic Doublet Proportion Estimate ----------------------------------------
annotations <- seuratobject@meta.data$seurat_clusters
homotypic.prop <- modelHomotypic(annotations)
#4.6% was selected based on number of cells recovered which in this sample case is 6065
nExp_poi <- round(0.046*nrow(seuratobject@meta.data))  ## Assuming 4.6% doublet formation rate 
nExp_poi.adj <- round(nExp_poi*(1-homotypic.prop))

## Run DoubletFinder with varying classification stringencies ------------------
#seuratobject <- doubletFinder(seuratobject, PCs = 1:10, pN = 0.25, pK = pK, nExp = nExp_poi, reuse.pANN = FALSE, sct = TRUE)
seuratobject <- doubletFinder(seuratobject, PCs = 1:15, pN = 0.25, pK = pK, nExp = nExp_poi.adj, reuse.pANN = FALSE, sct = TRUE)

#Visualize Doublets
DimPlot(seuratobject, reduction = "umap",  group.by = 'DF.classifications_0.25_0.02_258')
DimPlot(seuratobject, reduction = 'umap', split.by = "DF.classifications_0.25_0.02_258")
#Number of singlets and doublets
table(seuratobject@meta.data$DF.classifications_0.25_0.02_258)

#Select Singlets 
seuratobject <- subset(seuratobject, subset = DF.classifications_0.25_0.02_258 == "Singlet")

DimPlot(seuratobject, reduction = 'umap', label = TRUE)

save(seuratobject, file="seuratobject_SC2300015.RData")

########################################################################################################################
#Load SC2300016
patient.data <- Read10X(data.dir = "count_files/SC2300016/filtered_feature_bc_matrix/")

# Initialize the Seurat object with the raw (non-normalized data).
seurate.obj <- CreateSeuratObject(counts = patient.data, project="bovine", min.cells = 3, min.features = 200)

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
filtered_seurat <- subset(seurate.obj, subset = nFeature_RNA > 200 & nFeature_RNA < 4500 & percent.mt < 4)

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


#DoubletFinder
#https://rpubs.com/kenneditodd/doublet_finder_example
# pK Identification (no ground-truth) ------------------------------------------
sweep.res.list <- paramSweep(seuratobject, PCs = 1:15, sct = TRUE)
sweep.stats <- summarizeSweep(sweep.res.list, GT = FALSE)
bcmvn <- find.pK(sweep.stats)
pK <- bcmvn$pK[which.max(bcmvn$BCmetric)] %>% as.character() %>% as.numeric()

#ggplot(bcmvn, aes(pK, BCmetric, group=1)) + geom_point() + geom_line()

# Homotypic Doublet Proportion Estimate ----------------------------------------
annotations <- seuratobject@meta.data$seurat_clusters
homotypic.prop <- modelHomotypic(annotations)
#3.1% was selected based on number of cells recovered which in this sample case is 6065
nExp_poi <- round(0.031*nrow(seuratobject@meta.data))  ## Assuming 3.1% doublet formation rate 
nExp_poi.adj <- round(nExp_poi*(1-homotypic.prop))

## Run DoubletFinder with varying classification stringencies ------------------
#seuratobject <- doubletFinder(seuratobject, PCs = 1:10, pN = 0.25, pK = pK, nExp = nExp_poi, reuse.pANN = FALSE, sct = TRUE)
seuratobject <- doubletFinder(seuratobject, PCs = 1:15, pN = 0.25, pK = pK, nExp = nExp_poi.adj, reuse.pANN = FALSE, sct = TRUE)

#Visualize Doublets
DimPlot(seuratobject, reduction = "umap",  group.by = 'DF.classifications_0.25_0.04_133')
DimPlot(seuratobject, reduction = 'umap', split.by = "DF.classifications_0.25_0.04_133")
#Number of singlets and doublets
table(seuratobject@meta.data$DF.classifications_0.25_0.04_133)

#Select Singlets 
seuratobject <- subset(seuratobject, subset = DF.classifications_0.25_0.04_133 == "Singlet")

DimPlot(seuratobject, reduction = 'umap', label = TRUE)

save(seuratobject, file="seuratobject_SC2300016.RData")

########################################################################################################################
#Load SC2300017
patient.data <- Read10X(data.dir = "count_files/SC2300017/filtered_feature_bc_matrix/")

# Initialize the Seurat object with the raw (non-normalized data).
seurate.obj <- CreateSeuratObject(counts = patient.data, project="bovine", min.cells = 3, min.features = 200)

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
filtered_seurat <- subset(seurate.obj, subset = nFeature_RNA > 200 & nFeature_RNA < 4500 & percent.mt < 4)

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


#DoubletFinder
#https://rpubs.com/kenneditodd/doublet_finder_example
# pK Identification (no ground-truth) ------------------------------------------
sweep.res.list <- paramSweep(seuratobject, PCs = 1:15, sct = TRUE)
sweep.stats <- summarizeSweep(sweep.res.list, GT = FALSE)
bcmvn <- find.pK(sweep.stats)
pK <- bcmvn$pK[which.max(bcmvn$BCmetric)] %>% as.character() %>% as.numeric()

#ggplot(bcmvn, aes(pK, BCmetric, group=1)) + geom_point() + geom_line()

# Homotypic Doublet Proportion Estimate ----------------------------------------
annotations <- seuratobject@meta.data$seurat_clusters
homotypic.prop <- modelHomotypic(annotations)
#4.6% was selected based on number of cells recovered which in this sample case is 6065
nExp_poi <- round(0.046*nrow(seuratobject@meta.data))  ## Assuming 4.6% doublet formation rate 
nExp_poi.adj <- round(nExp_poi*(1-homotypic.prop))

## Run DoubletFinder with varying classification stringencies ------------------
#seuratobject <- doubletFinder(seuratobject, PCs = 1:10, pN = 0.25, pK = pK, nExp = nExp_poi, reuse.pANN = FALSE, sct = TRUE)
seuratobject <- doubletFinder(seuratobject, PCs = 1:15, pN = 0.25, pK = pK, nExp = nExp_poi.adj, reuse.pANN = FALSE, sct = TRUE)

#Visualize Doublets
DimPlot(seuratobject, reduction = "umap",  group.by = 'DF.classifications_0.25_0.02_186')
DimPlot(seuratobject, reduction = 'umap', split.by = "DF.classifications_0.25_0.02_186")
#Number of singlets and doublets
table(seuratobject@meta.data$DF.classifications_0.25_0.02_186)

#Select Singlets 
seuratobject <- subset(seuratobject, subset = DF.classifications_0.25_0.02_186 == "Singlet")

DimPlot(seuratobject, reduction = 'umap', label = TRUE)

save(seuratobject, file="seuratobject_SC2300017.RData")

########################################################################################################################


#Load SC2300018
patient.data <- Read10X(data.dir = "count_files/SC2300018/filtered_feature_bc_matrix/")

# Initialize the Seurat object with the raw (non-normalized data).
seurate.obj <- CreateSeuratObject(counts = patient.data, project="bovine", min.cells = 3, min.features = 200)

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
filtered_seurat <- subset(seurate.obj, subset = nFeature_RNA > 200 & nFeature_RNA < 4500 & percent.mt < 5)

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


#DoubletFinder
#https://rpubs.com/kenneditodd/doublet_finder_example
# pK Identification (no ground-truth) ------------------------------------------
sweep.res.list <- paramSweep(seuratobject, PCs = 1:15, sct = TRUE)
sweep.stats <- summarizeSweep(sweep.res.list, GT = FALSE)
bcmvn <- find.pK(sweep.stats)
pK <- bcmvn$pK[which.max(bcmvn$BCmetric)] %>% as.character() %>% as.numeric()

#ggplot(bcmvn, aes(pK, BCmetric, group=1)) + geom_point() + geom_line()

# Homotypic Doublet Proportion Estimate ----------------------------------------
annotations <- seuratobject@meta.data$seurat_clusters
homotypic.prop <- modelHomotypic(annotations)
#3.9% was selected based on number of cells recovered which in this sample case is 6065
nExp_poi <- round(0.039*nrow(seuratobject@meta.data))  ## Assuming 3.9% doublet formation rate 
nExp_poi.adj <- round(nExp_poi*(1-homotypic.prop))

## Run DoubletFinder with varying classification stringencies ------------------
#seuratobject <- doubletFinder(seuratobject, PCs = 1:10, pN = 0.25, pK = pK, nExp = nExp_poi, reuse.pANN = FALSE, sct = TRUE)
seuratobject <- doubletFinder(seuratobject, PCs = 1:15, pN = 0.25, pK = pK, nExp = nExp_poi.adj, reuse.pANN = FALSE, sct = TRUE)

#Visualize Doublets
DimPlot(seuratobject, reduction = "umap",  group.by = 'DF.classifications_0.25_0.05_188')
DimPlot(seuratobject, reduction = 'umap', split.by = "DF.classifications_0.25_0.05_188")
#Number of singlets and doublets
table(seuratobject@meta.data$DF.classifications_0.25_0.05_188)

#Select Singlets 
seuratobject <- subset(seuratobject, subset = DF.classifications_0.25_0.05_188 == "Singlet")

DimPlot(seuratobject, reduction = 'umap', label = TRUE)

save(seuratobject, file="seuratobject_SC2300018.RData")

########################################################################################################################


