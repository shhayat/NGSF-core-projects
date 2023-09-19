library(Seurat)

# Load the feature barcode matrix (.mtx)
counts_matrix <- Read10X(data.dir = "path/to/feature_barcodes.mtx")

# Create a Seurat object
seurat_obj <- CreateSeuratObject(counts = counts_matrix)

# Optionally, load cell and gene annotations
# Replace 'path/to/cell_barcodes.tsv' and 'path/to/gene_list.tsv' with the actual paths to your cell barcode and gene list files
cell_barcodes <- read.table("path/to/cell_barcodes.tsv", header = TRUE)
gene_list <- read.table("path/to/gene_list.tsv", header = TRUE)

# Add cell and gene annotations to the Seurat object
seurat_obj$meta.data <- cell_barcodes
rownames(seurat_obj) <- gene_list$gene_id
Make sure to replace the placeholder file paths with the actual paths to your respective files. Also, note that the actual steps and functions used may vary depending on your specific data and analysis requirements.





