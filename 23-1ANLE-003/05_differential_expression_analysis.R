library(Seurat)

# Load the feature barcode matrix (.mtx)

counts_matrix <- Read10X(data.dir = "/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANLE-003/analysis/agreggate/Scrambled_PBS/agreggate/outs/count/filtered_feature_bc_matrix/matrix.mtx")

# Create a Seurat object
seurat_obj <- CreateSeuratObject(counts = counts_matrix)

# Optionally, load cell and gene annotations
# Replace 'path/to/cell_barcodes.tsv' and 'path/to/gene_list.tsv' with the actual paths to your cell barcode and gene list files
cell_barcodes <- read.table("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANLE-003/analysis/agreggate/Scrambled_PBS/agreggate/outs/count/barcodes.tsv", header = TRUE)
gene_list <- read.table("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANLE-003/analysis/agreggate/Scrambled_PBS/agreggate/outs/count/features.tsv", header = TRUE)

# Add cell and gene annotations to the Seurat object
seurat_obj$meta.data <- cell_barcodes
rownames(seurat_obj) <- gene_list$gene_id






