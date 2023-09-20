library(Seurat)

# Load the feature barcode matrix (.mtx)
setwd(/Users/shahina/Desktop/23-1ANLE-003)
#counts_matrix <- Read10X(data.dir = "/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANLE-003/analysis/agreggate/Scrambled_PBS/agreggate/outs/count/filtered_feature_bc_matrix/")
counts_matrix <- Read10X(data.dir = "filtered_feature_bc_matrix")
levels(counts_matrix)
# Create a Seurat object
seurat_obj <- CreateSeuratObject(counts = counts_matrix)

monocyte.de.markers <- FindMarkers(seurat_obj, ident.1 = "CD14+ Mono", ident.2 = "FCGR3A+ Mono")



