#Batch Correction
https://www.10xgenomics.com/analysis-guides/batch-effect-correction-in-chromium-single-cell-atac-data

expression_matrix <- Read10X(data.dir = data_dir)
# Create a Seurat object
SeuratObject <- CreateSeuratObject(counts = expression_matrix,min.cells = 3,names.delim = "-", names.field = 2)


SC2300015 vs SC2300013
