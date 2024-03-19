#Cluster Annotation using SC-TYPE

setwd("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA-002/analysis")

load("seurat_object_SC2300019.RData")
SC2300019 <- seuratobject 
load("seurat_object_SC2300020.RData")
SC2300020 <- seuratobject 
load("seurat_object_SC2300021.RData")
SC2300021 <- seuratobject 
load("seurat_object_SC2300022.RData")
SC2300022 <- seuratobject 

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

cluster_analysis <- function(seuratobject, sample_name){
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

  pdf(sprintf("Cluster_annotation_%s.pdf",sample_name), width=10, height=10))
     DimPlot(seuratobject, reduction = "umap", label = TRUE, repel = TRUE, group.by = 'customclassif')
  dev.off()
}

cluster_analysis(SC2300019,"SC2300019")
cluster_analysis(SC2300020,"SC2300020")
cluster_analysis(SC2300021,"SC2300021")
cluster_analysis(SC2300022,"SC2300022")
