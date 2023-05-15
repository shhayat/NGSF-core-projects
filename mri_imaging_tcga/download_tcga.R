setwd("/Users/shahina/Projects/Dean_MRI_imaging_data_analysis/")
library("TCGAbiolinks")

# Defines the query to the GDC
query <- GDCquery(project = "TCGA-BRCA",
                  data.category = "Transcriptome Profiling",
                  data.type = "Gene Expression Quantification",
                  workflow.type = "STAR - Counts")
                 
#workflow.type = "STAR - Counts"
# Download data
GDCdownload(query)

#Prepare data
data <- GDCprepare(query)

#generate count matrix
counts = assay(data)
write.table(counts, "TNBC_count_matrix.txt", sep='\t')
