library(SCopeLoomR)
library(loomR)
library(pheatmap)
library(magrittr)
library(autonomics)

#loomfilecle = "/Users/shahina/Desktop/l1_cerebellum.agg.loom"
#loom <- open_loom(file.path = loomfilecle, mode = "r+")
#loom[["matrix"]]


loomfile = "/Users/shahina/Projects/20-1JOHO-001/l1_amygdala.agg.loom"
#loomfile = "/Users/shahina/Projects/20-1JOHO-001/l1_amygdala.loom"
loom <- open_loom(file.path = loomfile, mode = "r+")
loom[["matrix"]]

loom[["row_attrs/Gene"]]$dims

gene.names <- loom[["row_attrs/Gene"]][]
head(x = gene.names)


#loom[["attrs"]]
#loom[["col_graphs"]]
#loom[["layers"]]
#loom[["matrix"]]
#loom[["row_attrs"]]
#loom[["row_graphs"]]
mg <- data.frame(marker_genes=loom[["col_attrs/MarkerGenes"]][1:77])
#write.csv(mg,"/Users/shahina/Projects/20-1JOHO-001/marker_genes.csv", row.names = FALSE)


res <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts.txt", head=TRUE)

names(res) <-c("gene_name","treated_female_R25","treated_female_R26","control_male_R27","treated_male_R28",
               "control_male_R29","control_female_R30","treated_female_R31","control_female_R32",
               "treated_female_R33","control_female_R34","treated_female_R35","control_male_R36",
               "control_male_R37","control_male_R38","control_male_R39","treated_male_R40",
               "control_female_R41","control_female_R42","treated_female_R43","control_female_R44",
               "treated_female_R45","control_female_R46","treated_male_R47","treated_male_R48",
               "treated_female_R49","treated_male_R50","treated_male_R51","control_female_R52",
               "treated_female_R53","treated_female_R54","treated_male_R55","control_male_R56",
               "treated_male_R57","control_female_R58","control_male_R59","treated_male_R60",
               "control_male_R61","treated_female_R62","treated_male_R63","treated_male_R64")

df <- strsplit(mg$marker_genes, " ")
df <- unlist(df)
#395
df_nodup <- df[!duplicated(df)]
#359
df1 <- res[tolower(res$gene_name) %in% tolower(df_nodup),]
rownames(df1) <- df1$gene_name
df1 <- df1[-1]

df2_female <- data.frame(df1[grep("treated_female",names(df1))], df1[grep("control_female",names(df1))])
df2_female <- df2_female[rowSums(df2_female[1:length(df2_female)])> 0, ]

df2_male <- data.frame(df1[grep("treated_male",names(df1))], df1[grep("control_male",names(df1))])
df2_male <- df2_male[rowSums(df2_male[1:length(df2_male)])> 0, ]


######################
#HEATMAP ON MARKERS
######################
bwcolor = grDevices::colorRampPalette(c("yellow","grey", "blue"))
pheatmap(
  df2_female,
  filename   ="/Users/shahina/Projects/20-1JOHO-001/results/female_heatmap_on_markers.pdf",
  clustering_dist_rows = "correlation",
  scale      = 'row',
  cellheight = 8,
  cellwidth =  8,
  fontsize   = 6,
  col        = bwcolor(50),
  treeheight_row = 0,
  treeheight_col = 50,
  cluster_cols = TRUE,
  border_color = NA)

bwcolor = grDevices::colorRampPalette(c("yellow","grey", "blue"))
pheatmap(
  df2_male,
  filename   ="/Users/shahina/Projects/20-1JOHO-001/results/male_heatmap_on_markers.pdf",
  clustering_dist_rows = "correlation",
  scale      = 'row',
  cellheight = 8,
  cellwidth =  8,
  fontsize   = 6,
  col        = bwcolor(50),
  treeheight_row = 0,
  treeheight_col = 50,
  cluster_cols = TRUE,
  border_color = NA)


####################################
#RUN AUTONOMICS ON MARKER GENES
####################################
setwd("/Users/shahina/Projects/20-1JOHO-001")
res <- read.table("20-1JOHO-001_htseq_counts.txt", head=TRUE)

names(res) <-c("gene_name","treated_female_R25","treated_female_R26","control_male_R27","treated_male_R28",
               "control_male_R29","control_female_R30","treated_female_R31","control_female_R32",
               "treated_female_R33","control_female_R34","treated_female_R35","control_male_R36",
               "control_male_R37","control_male_R38","control_male_R39","treated_male_R40",
               "control_female_R41","control_female_R42","treated_female_R43","control_female_R44",
               "treated_female_R45","control_female_R46","treated_male_R47","treated_male_R48",
               "treated_female_R49","treated_male_R50","treated_male_R51","control_female_R52",
               "treated_female_R53","treated_female_R54","treated_male_R55","control_male_R56",
               "treated_male_R57","control_female_R58","control_male_R59","treated_male_R60",
               "control_male_R61","treated_female_R62","treated_male_R63","treated_male_R64")

#2. Male Treated and Male Control
res_treated_and_control_male <- data.frame(res[1], res[grep("treated_male",names(res))], res[grep("control_male",names(res))])
#3. Female Treated and Female Control
res_treated_and_control_female <- data.frame(res[1], res[grep("treated_female",names(res))], res[grep("control_female",names(res))])

res_treated_and_control_male <- res_treated_and_control_male[res_treated_and_control_male$gene_name %in% rownames(df1),]
res_treated_and_control_female <- res_treated_and_control_female[res_treated_and_control_female$gene_name %in% rownames(df1),]

write.table(res_treated_and_control_male, "/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_M_marker_genes.txt", sep="\t", quote=FALSE, , row.names=FALSE)
write.table(res_treated_and_control_female, "/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F_marker_genes.txt", sep="\t", quote=FALSE, , row.names=FALSE)

#PCA for all samples
pdf("pca_male_on_markers.pdf")
  object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_M_marker_genes.txt", pca = TRUE , plot = TRUE)
  #object <- object %>% filter_samples(!sample_id %in% c("treated_male_R55","treated_male_R64"))
  #biplot(object, pca1, pca2, label=sample_id, color=subgroup)
  biplot(object, pca1, pca2, label=sample_id,color=subgroup)
dev.off()

pdf("pca_female_on_markers.pdf")
  object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F_marker_genes.txt", pca = TRUE , plot = TRUE)
  biplot(object, pca1, pca2, label=sample_id, color=subgroup)
dev.off()

#############################
#PCA after dropping samples
#############################
#drop round1: 41, 58, 31, 26, 35, 33 
#pdf("pca_female_drop_round1.pdf")
pdf("pca_female_after_dropping_samples.pdf", width=15, height=10)
object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F_marker_genes.txt", pca = TRUE , plot = FALSE)
object1 <- object %>% filter_samples(!sample_id %in% c("control_female_R41","control_female_R58","treated_female_R31","treated_female_R26","treated_female_R35","treated_female_R33"))
p1 <- biplot(object1, pca1, pca2, label=sample_id,color=subgroup) + ggplot2::ggtitle("Female Round1 Dropped: 41, 58, 31, 26, 35, 33")

#drop round1+2: 41, 58, 31, 26, 35, 33, 53
object2 <- object %>% filter_samples(!sample_id %in% c("control_female_R41","control_female_R58","treated_female_R31","treated_female_R26","treated_female_R35","treated_female_R33","treated_female_R53"))
p2 <- biplot(object2, pca1, pca2, label=sample_id,color=subgroup) + ggplot2::ggtitle("Female Round1+2 Dropped: 53")

#drop round1+2+3: 41, 58, 31, 26, 35, 33, 53,49
object3 <- object %>% filter_samples(!sample_id %in% c("control_female_R41","control_female_R58","treated_female_R31","treated_female_R26","treated_female_R35","treated_female_R33","treated_female_R53","treated_female_R49"))
p3 <- biplot(object3, pca1, pca2, label=sample_id,color=subgroup) + ggplot2::ggtitle("Female Round1+2+3 Dropped: 49")

ggpubr::ggarrange(p1, p2, p3,
                  ncol = 2, nrow = 2)
dev.off()


#drop round1:61, 59, 56, 63, 40, 28	
pdf("pca_male_after_dropping_samples.pdf", width=15)
object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_M_marker_genes.txt", pca = TRUE , plot = FALSE)
object1 <- object %>% filter_samples(!sample_id %in% c("control_male_R61","control_male_R59","control_male_R56","treated_male_R63","treated_male_R40","treated_male_R28"))
p4 <- biplot(object1, pca1, pca2, label=sample_id, color=subgroup) + ggplot2::ggtitle("Male Round1 Dropped: 61, 59, 56, 63, 40, 28")

#drop round1+2:61, 59, 56, 63, 40, 28, 55, 64	
object2 <- object %>% filter_samples(!sample_id %in% c("control_male_R61","control_male_R59","control_male_R56","treated_male_R63","treated_male_R40","treated_male_R28","treated_male_R55","treated_male_R64"))
p5 <- biplot(object2, pca1, pca2, label=sample_id, color=subgroup) + ggplot2::ggtitle("Male Round1+2 Dropped: 55, 64")

ggpubr::ggarrange(p4, p5,
                  ncol = 2, nrow = 1)
dev.off()


#########################################################
#DIFFERENTIAL EXPRESSIONS AFTER REMOVING SAMPLES
#########################################################

library("autonomics")
setwd("/Users/shahina/Projects/20-1JOHO-001")

#exclude male samples
DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_M.txt", head=TRUE)
DF1 <- subset(DF, select=-c(control_male_R61,control_male_R59,control_male_R56,treated_male_R63,treated_male_R40,treated_male_R28,treated_male_R55,treated_male_R64))
write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_M_samples_excluded.txt", quote=FALSE, sep="\t", row.names = FALSE)

pdf("/Users/shahina/Projects/20-1JOHO-001/results/treated_and_control_male_round1+2.pdf")
  object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_M_samples_excluded.txt",  pca = TRUE , plot = FALSE)
  biplot(object, pca1, pca2, label=sample_id, color=subgroup)
  object2 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('subgrouptreated_male - subgroupcontrol_male'), plot = FALSE)
dev.off()

  fdata1 <- data.frame(fdt(object2))
  fdata1_select <- fdata1[c(2,5,6,7)]
  fdata1_pval=fdata1_select[fdata1_select[4] <=0.05,]
  names(fdata1_pval) <- c("gene_name","effects","pvalue", "fdr")
  write.csv(fdata1_pval,"/Users/shahina/Projects/20-1JOHO-001/results/treated_and_control_male_round1+2.csv")
 

  
#####################
#BOX PLOT FOR PENK
#####################

pdf("/Users/shahina/Projects/20-1JOHO-001/plots/boxplot_males.pdf")
  object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_M.txt", plot = FALSE, cpm=TRUE, log2 = TRUE)
  object <- filter_features(object,   feature_name=='Penk',  verbose = TRUE)
  p1 <- plot_subgroup_boxplots(object, subgroup=subgroup, jitter = FALSE) + ggplot2::ggtitle("All samples included")

  #round1
  DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_M.txt", head=TRUE)
  DF1 <- subset(DF, select=-c(control_male_R61,control_male_R59,control_male_R56,treated_male_R63,treated_male_R40,treated_male_R28))  
  write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_M_samples_excluded_round1.txt", quote=FALSE, sep="\t", row.names = FALSE)

  object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_M_samples_excluded_round1.txt", plot = FALSE, cpm=TRUE, log2 = TRUE)
  object <- filter_features(object,   feature_name=='Penk',  verbose = TRUE)
  p2 <- plot_subgroup_boxplots(object, subgroup=subgroup, jitter = FALSE) + ggplot2::ggtitle("Round 1")

  #round1+2
  #exclude male samples round1+2
  DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_M.txt", head=TRUE)
  DF1 <- subset(DF, select=-c(control_male_R61,control_male_R59,control_male_R56,treated_male_R63,treated_male_R40,treated_male_R28,treated_male_R55,treated_male_R64))  
  write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_M_samples_excluded_round1+2.txt", quote=FALSE, sep="\t", row.names = FALSE)

  object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_M_samples_excluded_round1+2.txt", plot = FALSE, cpm=TRUE, log2 = TRUE)
  object <- filter_features(object,   feature_name=='Penk',  verbose = TRUE)
  p3 <- plot_subgroup_boxplots(object, subgroup=subgroup, jitter = FALSE) + ggplot2::ggtitle("Round 1+2")

  ggpubr::ggarrange(p1, p2, p3,ncol = 2, nrow = 2)
dev.off()



pdf("/Users/shahina/Projects/20-1JOHO-001/plots/boxplot_females.pdf")
  object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt", plot = FALSE, cpm=TRUE, log2 = TRUE)
  object <- filter_features(object,   feature_name=='Penk',  verbose = TRUE)
  p1 <- plot_subgroup_boxplots(object, subgroup=subgroup, jitter = FALSE) + ggplot2::ggtitle("All samples included")

  #round1
  DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt", head=TRUE,, cpm=TRUE, log2 = TRUE)
  DF1 <- subset(DF, select=-c(control_female_R41,control_female_R58,treated_female_R31,treated_female_R26,treated_female_R35,treated_female_R33))  
  write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_round1.txt", quote=FALSE, sep="\t", row.names = FALSE)

  object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_round1.txt", plot = FALSE, cpm=TRUE, log2 = TRUE)
  object <- filter_features(object,   feature_name=='Penk',  verbose = TRUE)
  p2 <- plot_subgroup_boxplots(object, subgroup=subgroup, jitter = FALSE) + ggplot2::ggtitle("Round 1")

  #round1+2
  DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt", head=TRUE)
  DF1 <- subset(DF, select=-c(control_female_R41,control_female_R58,treated_female_R31,treated_female_R26,treated_female_R35,treated_female_R33,treated_female_R53))  
  write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_round1+2.txt", quote=FALSE, sep="\t", row.names = FALSE)

  object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_round1+2.txt", plot = FALSE, cpm=TRUE, log2 = TRUE)
  object <- filter_features(object,   feature_name=='Penk',  verbose = TRUE)
  p3 <- plot_subgroup_boxplots(object, subgroup=subgroup, jitter = FALSE) + ggplot2::ggtitle("Round 1+2")

  #round1+2+3
  DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt", head=TRUE)
  DF1 <- subset(DF, select=-c(control_female_R41,control_female_R58,treated_female_R31,treated_female_R26,treated_female_R35,treated_female_R33,treated_female_R53,treated_female_R49))  
  write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_round1+2+3.txt", quote=FALSE, sep="\t", row.names = FALSE)

  object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_round1+2+3.txt", plot = FALSE, cpm=TRUE, log2 = TRUE)
  object <- filter_features(object,   feature_name=='Penk',  verbose = TRUE)
  p4 <- plot_subgroup_boxplots(object, subgroup=subgroup, jitter = FALSE) + ggplot2::ggtitle("Round 1+2+3")

  ggpubr::ggarrange(p1, p2, p3,p4, ncol = 2, nrow = 2)
dev.off()
