library(sva)
library(magrittr)
library(DESeq2)
library(ggplot2)
###################
#SVA ON ALL GENES
###################
male_expr <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_M.txt", head=TRUE)
row.names(male_expr) <- male_expr$gene_name
male_expr<- male_expr[-1]

filtered <- male_expr %>% dplyr::filter_at(dplyr::vars(1:20), dplyr::all_vars(. > 1))

sample_name=c("treated_male_R28","treated_male_R40","treated_male_R47","treated_male_R48","treated_male_R50","treated_male_R51",
               "treated_male_R55","treated_male_R57", "treated_male_R60", "treated_male_R63", "treated_male_R64","control_male_R27", 
               "control_male_R29", "control_male_R36", "control_male_R37","control_male_R38", "control_male_R39", "control_male_R56",
               "control_male_R59", "control_male_R61") 

sample_count <- c(1:20)

condition <- c("treated","treated","treated","treated","treated","treated","treated","treated","treated","treated","treated",
               "control","control","control","control","control","control","control","control","control")

pheno <- data.frame(sample_count,condition)
rownames(pheno) <- sample_name

mod = model.matrix(~as.factor(condition), data=pheno)
mod0 = model.matrix(~1,data=pheno)

dds <- DESeqDataSetFromMatrix(filtered, pheno, ~condition)
dds <- estimateSizeFactors(dds)
norm.expr <- counts(dds, normalized=TRUE)
norm.expr <- as.data.frame(norm.expr)

fit <- svaseq(as.matrix(norm.expr), mod=mod, mod0=mod0)
rownames(fit$sv) <- rownames(pheno)
dds$cond.int <- as.integer(dds$condition) + 15

#2D PLOT
plot(fit$sv[,1:2], col=dds$condition, pch=dds$cond.int, cex=1.5,xlab="SV1", ylab="SV2")
text(fit$sv[,1:2], labels=rownames(fit$sv), cex=0.5, font=2,pos=1)

library(rgl)
plot3d(fit$sv[,1:3], col=c(1:3), size=4, type='p', xlab="SV1", ylab="SV2", zlab="SV3")
#text3d(fit$sv[,1], fit$sv[,2],fit$sv[,3],texts=rownames(fit$sv), cex= 0.6, pos=1)
rglwidget() 

#write.csv(fit$sv[,1:3], "/Users/shahina/Desktop/female_sva.csv", row.names = TRUE)

#ddssva <- dds
#ddssva$SV1 <- fit$sv[,1]
#ddssva$SV2 <- fit$sv[,2]
#design(ddssva) <- ~ SV1 + SV2 + condition
#ddssva <- DESeq(ddssva)

#vsd <- varianceStabilizingTransformation(ddssva)

#vsd$sample_names <- rownames(colData(vsd))
# PCA plot
#plotPCA(vsd, intgroup="condition") + 
#  ggplot2::geom_text(ggplot2::aes(label = rownames(colData(vsd))), nudge_y=0.5)

ddssva$condition <- factor(ddssva$condition, levels = c("control","treated"))
ddssva$condition <- relevel(ddssva$condition, ref = "control")
res <- results(ddssva)


female_expr <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt", head=TRUE)
row.names(female_expr) <- female_expr$gene_name
female_expr<- female_expr[-1]

filtered <- female_expr %>% dplyr::filter_at(dplyr::vars(1:20), dplyr::all_vars(. > 1))

sample_name=c("treated_female_R25", "treated_female_R26", "treated_female_R31", "treated_female_R33",
              "treated_female_R35", "treated_female_R43", "treated_female_R45", "treated_female_R49",
              "treated_female_R53", "treated_female_R54", "treated_female_R62", "control_female_R30",
              "control_female_R32", "control_female_R34", "control_female_R41", "control_female_R42",
              "control_female_R44", "control_female_R46", "control_female_R52", "control_female_R58") 

sample_count <- c(1:20)

condition <- c("treated","treated","treated","treated","treated","treated","treated","treated","treated","treated","treated",
               "control","control","control","control","control","control","control","control","control")

pheno <- data.frame(sample_count,condition)
rownames(pheno) <- sample_name

mod = model.matrix(~as.factor(condition), data=pheno)
mod0 = model.matrix(~1,data=pheno)

dds <- DESeqDataSetFromMatrix(filtered, pheno, ~condition)
dds <- estimateSizeFactors(dds)
norm.expr <- counts(dds, normalized=TRUE)
norm.expr <- as.data.frame(norm.expr)

fit <- svaseq(as.matrix(norm.expr), mod=mod, mod0=mod0)
rownames(fit$sv) <- rownames(pheno)
dds$cond.int <- as.integer(dds$condition) + 15
plot(fit$sv[,1:2], col=dds$condition, pch=dds$cond.int, cex=1.5,xlab="SV1", ylab="SV2")
text(fit$sv[,1:2], labels=rownames(fit$sv), cex=0.5, font=2,pos=1)

rownames(fit$sv) <- pheno$condition
write.csv(fit$sv,"/Users/shahina/Desktop/female_sva_on_all_genes.csv", row.names=TRUE)

#library(rgl)
#plot3d(fit$sv[,1:3], col=c(1:3), size=4, type='p', xlab="SV1", ylab="SV2", zlab="SV3")
#text3d(fit$sv[,1], fit$sv[,2],fit$sv[,3],texts=rownames(fit$sv), cex= 0.6, pos=1)
#rglwidget() 

#fit1 <- as.data.frame(fit$sv)
#colnames(fit1) <- c('SV1','SV2','SV3')
#ggplot(fit1, aes(SV1, SV2)) + 
#  geom_point(aes(colour = factor(pheno$condition)), size=1.5) +
#  geom_text(aes(label = rownames(pheno)))
  

#ddssva <- dds
#ddssva$SV1 <- fit$sv[,1]
#ddssva$SV2 <- fit$sv[,2]
#design(ddssva) <- ~ SV1 + SV2 + condition
#ddssva <- DESeq(ddssva)

#vsd <- varianceStabilizingTransformation(ddssva)

#vsd$sample_names <- rownames(colData(vsd))
# PCA plot
#plotPCA(vsd, intgroup="condition") + 
#  ggplot2::geom_text(ggplot2::aes(label = rownames(colData(vsd))), nudge_y=0.5)
#ddssva$condition <- factor(ddssva$condition, levels = c("control","treated"))
#ddssva$condition <- relevel(ddssva$condition, ref = "control")
#res <- results(ddssva)


####################
#SVA ON MARKER GENES
####################

markers_M <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_M_marker_genes.txt", head=TRUE)

row.names(markers_M) <- markers_M$gene_name
markers_M <- markers_M[-1]

filtered <- markers_M %>% dplyr::filter_at(dplyr::vars(1:20), dplyr::all_vars(. > 1))

sample_name=c("treated_male_R28","treated_male_R40","treated_male_R47","treated_male_R48","treated_male_R50","treated_male_R51",
              "treated_male_R55","treated_male_R57", "treated_male_R60", "treated_male_R63", "treated_male_R64","control_male_R27", 
              "control_male_R29", "control_male_R36", "control_male_R37","control_male_R38", "control_male_R39", "control_male_R56",
              "control_male_R59", "control_male_R61") 

sample_count <- c(1:20)
condition <- c("treated","treated","treated","treated","treated","treated","treated","treated","treated","treated","treated",
               "control","control","control","control","control","control","control","control","control")

pheno <- data.frame(sample_count,condition)
rownames(pheno) <- sample_name

mod = model.matrix(~as.factor(condition), data=pheno)
mod0 = model.matrix(~1,data=pheno)

dds <- DESeqDataSetFromMatrix(filtered, pheno, ~condition)
dds <- estimateSizeFactors(dds)
norm.expr <- counts(dds, normalized=TRUE)
norm.expr <- as.data.frame(norm.expr)

fit <- svaseq(as.matrix(norm.expr), mod=mod, mod0=mod0)
rownames(fit$sv) <- rownames(pheno)
dds$cond.int <- as.integer(dds$condition) + 15

plot(fit$sv[,1:2], col=dds$condition, pch=dds$cond.int, cex=1.2,xlab="SV1", ylab="SV2")
text(fit$sv[,1:2], labels=rownames(fit$sv), cex=0.5, font=2,pos=1)


ddssva <- dds
ddssva$SV1 <- fit$sv[,1]
ddssva$SV2 <- fit$sv[,2]
design(ddssva) <- ~ SV1 + SV2 + condition
ddssva <- DESeq(ddssva)
ddssva$condition <- factor(ddssva$condition, levels = c("control","treated"))
ddssva$condition <- relevel(ddssva$condition, ref = "control")
res <- results(ddssva)
res[res$padj <= 0.05,]




markers_F <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F_marker_genes.txt", head=TRUE)
row.names(markers_F) <- markers_F$gene_name
markers_F<- markers_F[-1]

filtered <- markers_F %>% dplyr::filter_at(dplyr::vars(1:20), dplyr::all_vars(. > 1))

sample_name=c("treated_female_R25", "treated_female_R26", "treated_female_R31", "treated_female_R33",
              "treated_female_R35", "treated_female_R43", "treated_female_R45", "treated_female_R49",
              "treated_female_R53", "treated_female_R54", "treated_female_R62", "control_female_R30",
              "control_female_R32", "control_female_R34", "control_female_R41", "control_female_R42",
              "control_female_R44", "control_female_R46", "control_female_R52", "control_female_R58") 

sample_count <- c(1:20)

condition <- c("treated","treated","treated","treated","treated","treated","treated","treated","treated","treated","treated",
               "control","control","control","control","control","control","control","control","control")

pheno <- data.frame(sample_count,condition)
rownames(pheno) <- sample_name

mod = model.matrix(~as.factor(condition), data=pheno)
mod0 = model.matrix(~1,data=pheno)

dds <- DESeqDataSetFromMatrix(filtered, pheno, ~condition)
dds <- estimateSizeFactors(dds)
norm.expr <- counts(dds, normalized=TRUE)
norm.expr <- as.data.frame(norm.expr)

fit <- svaseq(as.matrix(norm.expr), mod=mod, mod0=mod0)
rownames(fit$sv) <- rownames(pheno)
dds$cond.int <- as.integer(dds$condition) + 15
plot(fit$sv[,1:2], col=dds$condition, pch=dds$cond.int, cex=1.2,xlab="SV1", ylab="SV2")
text(fit$sv[,1:2], labels=rownames(fit$sv), cex=0.6, font=2,pos=1)

rownames(fit$sv) <- pheno$condition
write.csv(fit$sv,"/Users/shahina/Desktop/female_sva_on_marker_set1.csv", row.names=TRUE)


ddssva <- dds
ddssva$SV1 <- fit$sv[,1]
ddssva$SV2 <- fit$sv[,2]
design(ddssva) <- ~ SV1 + SV2 + condition
ddssva <- DESeq(ddssva)
ddssva$condition <- factor(ddssva$condition, levels = c("control","treated"))
ddssva$condition <- relevel(ddssva$condition, ref = "control")
res <- results(ddssva)
res[res$padj <= 0.05,]


library(pca3d)
library(rgl)
pca3d(fit$sv[,1:3], group=dds$condition)
rglwidget() 
#snapshotPCA3d(file="/Users/shahina/Desktop/first_plot.png")

pca2d(fit$sv, group=dds$condition, legend="topleft",show.labels=TRUE)
pca2d(fit$sv, group=dds$condition, biplot=TRUE, biplot.vars=3)


library(rgl)
plot3d(fit$sv[,1:3], col=c(1:3), size=4, type='p', xlab="SV1", ylab="SV2", zlab="SV3")
text3d(fit$sv[,1], fit$sv[,2],fit$sv[,3],texts=rownames(fit$sv), cex= 0.6, pos=1)
rglwidget() 

#output image
#rgl.snapshot("3Dpca_female_marker.png", "png") 
#ouput pdf:
#rgl.postscript("3Dpca_female_marker.pdf", "pdf")


#############################
#SVA USING DIFFERENT MARKERS
#############################
markers_F <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F_marker_genes_another_set.txt", head=TRUE)

row.names(markers_F) <- markers_F$gene_name
markers_F<- markers_F[-1]

filtered <- markers_F %>% dplyr::filter_at(dplyr::vars(1:20), dplyr::all_vars(. > 1))

sample_name=c("treated_female_R25", "treated_female_R26", "treated_female_R31", "treated_female_R33",
              "treated_female_R35", "treated_female_R43", "treated_female_R45", "treated_female_R49",
              "treated_female_R53", "treated_female_R54", "treated_female_R62", "control_female_R30",
              "control_female_R32", "control_female_R34", "control_female_R41", "control_female_R42",
              "control_female_R44", "control_female_R46", "control_female_R52", "control_female_R58") 

sample_count <- c(1:20)

condition <- c("treated","treated","treated","treated","treated","treated","treated","treated","treated","treated","treated",
               "control","control","control","control","control","control","control","control","control")

pheno <- data.frame(sample_count,condition)
rownames(pheno) <- sample_name

mod = model.matrix(~as.factor(condition), data=pheno)
mod0 = model.matrix(~1,data=pheno)

dds <- DESeqDataSetFromMatrix(filtered, pheno, ~condition)
dds <- estimateSizeFactors(dds)
norm.expr <- counts(dds, normalized=TRUE)
norm.expr <- as.data.frame(norm.expr)

fit <- svaseq(as.matrix(norm.expr), mod=mod, mod0=mod0)
rownames(fit$sv) <- rownames(pheno)
dds$cond.int <- as.integer(dds$condition) + 15
plot(fit$sv[,1:2], col=dds$condition, pch=dds$cond.int, cex=1.2,xlab="SV1", ylab="SV2")
text(fit$sv[,1:2], labels=rownames(fit$sv), cex=0.5, font=2,pos=1)


rownames(fit$sv) <- pheno$condition
write.csv(fit$sv,"/Users/shahina/Desktop/female_sva_on_marker_set2.csv", row.names=TRUE)

ddssva <- dds
ddssva$SV1 <- fit$sv[,1]
ddssva$SV2 <- fit$sv[,2]
design(ddssva) <- ~ SV1 + SV2 + condition
ddssva <- DESeq(ddssva)
ddssva$condition <- factor(ddssva$condition, levels = c("control","treated"))
ddssva$condition <- relevel(ddssva$condition, ref = "control")
res <- results(ddssva)
res[res$padj <= 0.05,]

library(rgl)
plot3d(fit$sv[,1:2], col=c(1:2), size=4, type='p', xlab="SV1", ylab="SV2", zlab="SV3")
text3d(fit$sv[,1], fit$sv[,2],texts=rownames(fit$sv), cex= 0.6, pos=1)
rglwidget() 

#rgl.snapshot("3DPCA-Merge.png", "png") 
#rgl.postscript("3Dpca_female_marker.pdf", "pdf")
#sample_name=c("treated_female_low_R25","treated_female_high_R26","treated_female_high_R31","treated_female_high_R33",
#"treated_female_low_R35","treated_female_high_R43","treated_female_high_R45","treated_female_high_R49",
#"treated_female_low_R53","treated_female_high_R54","treated_female_high_R62","control_female_high_R30",
#"control_female_low_R32","control_female_high_R34","control_female_low_R41","control_female_low_R42",
#"control_female_high_R44","control_female_high_R46","control_female_low_R52","control_female_high_R58")
