
###############################################################################
#histograms Pvalue for males after excluding samples and female all samples
###############################################################################
library(ggplot2)

#Male All samples
object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_M.txt",  pca = FALSE , plot = FALSE)
object2 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('subgrouptreated_male - subgroupcontrol_male'), plot = FALSE)

fdata1 <- data.frame(fdt(object2))
fdata1_pval=fdata1[fdata1[4] <=0.05,]

p1 <- ggplot(fdata1, aes(x = p.subgrouptreated_male...subgroupcontrol_male.limma)) + 
          geom_histogram(colour = 4, fill = "white") + 
          labs(x = "p.value", title = "Males All Samples: Pvalues <=0.05 = 2101 genes and FDR(<0.05) = 0 genes")

#Males after removing 4 samples
object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_M_samples_excluded.txt",  pca = FALSE , plot = FALSE)
object2 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('subgrouptreated_male - subgroupcontrol_male'), plot = FALSE)

fdata1 <- data.frame(fdt(object2))
fdata1_pval=fdata1[fdata1[4] <=0.05,]

p2 <- ggplot(fdata1, aes(x = p.subgrouptreated_male...subgroupcontrol_male.limma)) + 
          geom_histogram(colour = 4, fill = "white") + 
          labs(x = "p.value", title = "Males All Samples: Pvalues <=0.05 = 2101 genes and FDR(<0.05) = 0 genes")
          

#Female all samples
object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt",  pca = FALSE , plot = FALSE)
object2 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('subgrouptreated_female - subgroupcontrol_female'), plot = FALSE)

fdata1 <- data.frame(fdt(object2))
fdata1_pval=fdata1[fdata1[4] <=0.05,]
p3 <- ggplot(fdata1, aes(x = p.subgrouptreated_female...subgroupcontrol_female.limma)) + 
          geom_histogram(colour = 4, fill = "white") +
          labs(x = "p.value", title = "Females All Samples: Pvalues(<=0.05) = 245 genes and FDR(<0.05) = 0 genes")


pdf("/Users/shahina/Projects/20-1JOHO-001/plots/histograms.pdf", width=8)
ggpubr::ggarrange(p1, p2,p3,
                  ncol = 1, nrow = 3)
dev.off()

###################################
#histograms Pvalue only for females
###################################

#Female exclude 3 samples
DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt", head=TRUE)
#apart from marker set1 samples we had to also remove other samples which were inter mixing treated_female_R25,control_female_R44,control_female_R46,control_female_R52, treated_female_R45,treated_female_R43
#control_female_R41,control_female_R58,treated_female_R31,treated_female_R26,treated_female_R35,treated_female_R33,treated_female_R53,treated_female_R25,control_female_R44,control_female_R46,control_female_R52,treated_female_R45,treated_female_R43
DF1 <- subset(DF, select=-c(control_female_R41,control_female_R58,control_female_R44))
write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_3samples.txt", quote=FALSE, sep="\t", row.names = FALSE)

object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_3samples.txt",  pca = TRUE , plot = FALSE)
biplot(object, pca1, pca2, label=sample_id, color=subgroup)
object2 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('subgrouptreated_female - subgroupcontrol_female'), plot = FALSE)

fdata1 <- data.frame(fdt(object2))
fdata1_pval=fdata1[fdata1[6] <=0.05,]
nrow(fdata1_pval)
fdata1_fdr=fdata1[fdata1[7] <=0.05,]
nrow(fdata1_fdr)

p1 <- ggplot(fdata1, aes(x = p.subgrouptreated_female...subgroupcontrol_female.limma)) + 
   geom_histogram(colour = 4, fill = "white") +
   labs(x = "p.value", title = paste0("Females 3 samples excluded: Pvalues(<=0.05) =", nrow(fdata1_pval)," genes and FDR(<0.05) =",nrow(fdata1_fdr)," genes"))

#Female exclude 5 samples
DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt", head=TRUE)
#apart from marker set1 samples we had to also remove other samples which were inter mixing treated_female_R25,control_female_R44,control_female_R46,control_female_R52, treated_female_R45,treated_female_R43
#control_female_R41,control_female_R58,treated_female_R31,treated_female_R26,treated_female_R35,treated_female_R33,treated_female_R53,treated_female_R25,control_female_R44,control_female_R46,control_female_R52,treated_female_R45,treated_female_R43
DF1 <- subset(DF, select=-c(control_female_R41,control_female_R58,control_female_R44,control_female_R52,control_female_R46))
write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_5samples.txt", quote=FALSE, sep="\t", row.names = FALSE)

object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_5samples.txt",  pca = TRUE , plot = FALSE)
biplot(object, pca1, pca2, label=sample_id, color=subgroup)
object2 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('subgrouptreated_female - subgroupcontrol_female'), plot = FALSE)

fdata1 <- data.frame(fdt(object2))
fdata1_pval=fdata1[fdata1[6] <=0.05,]
nrow(fdata1_pval)
fdata1_fdr=fdata1[fdata1[7] <=0.05,]
nrow(fdata1_fdr)

p2 <- ggplot(fdata1, aes(x = p.subgrouptreated_female...subgroupcontrol_female.limma)) + 
  geom_histogram(colour = 4, fill = "white") +
  labs(x = "p.value", title = paste0("Females 5 Samples Excluded: Pvalues(<=0.05) =", nrow(fdata1_pval)," genes and FDR(<0.05) =",nrow(fdata1_fdr)," genes"))



#Female exclude 7 samples
DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt", head=TRUE)
#apart from marker set1 samples we had to also remove other samples which were inter mixing treated_female_R25,control_female_R44,control_female_R46,control_female_R52, treated_female_R45,treated_female_R43
#control_female_R41,control_female_R58,treated_female_R31,treated_female_R26,treated_female_R35,treated_female_R33,treated_female_R53,treated_female_R25,control_female_R44,control_female_R46,control_female_R52,treated_female_R45,treated_female_R43
DF1 <- subset(DF, select=-c(control_female_R41,control_female_R58,control_female_R44,control_female_R52,control_female_R46,treated_female_R31,treated_female_R35))
write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_7samples.txt", quote=FALSE, sep="\t", row.names = FALSE)

object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_7samples.txt",  pca = TRUE , plot = FALSE)
biplot(object, pca1, pca2, label=sample_id, color=subgroup)
object2 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('subgrouptreated_female - subgroupcontrol_female'), plot = FALSE)

fdata1 <- data.frame(fdt(object2))
fdata1_pval=fdata1[fdata1[6] <=0.05,]
nrow(fdata1_pval)
fdata1_fdr=fdata1[fdata1[7] <=0.05,]
nrow(fdata1_fdr)

p3 <- ggplot(fdata1, aes(x = p.subgrouptreated_female...subgroupcontrol_female.limma)) + 
  geom_histogram(colour = 4, fill = "white") +
  labs(x = "p.value", title = paste0("Females 7 Samples Excluded: Pvalues(<=0.05) =", nrow(fdata1_pval)," genes and FDR(<0.05) =",nrow(fdata1_fdr)," genes"))


#Female exclude 10 samples
DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt", head=TRUE)
#apart from marker set1 samples we had to also remove other samples which were inter mixing treated_female_R25,control_female_R44,control_female_R46,control_female_R52, treated_female_R45,treated_female_R43
#control_female_R41,control_female_R58,treated_female_R31,treated_female_R26,treated_female_R35,treated_female_R33,treated_female_R53,treated_female_R25,control_female_R44,control_female_R46,control_female_R52,treated_female_R45,treated_female_R43
DF1 <- subset(DF, select=-c(control_female_R41,control_female_R58,control_female_R44,control_female_R52,control_female_R46,treated_female_R31,treated_female_R35,treated_female_R26,treated_female_R33,treated_female_R25))
write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_10samples.txt", quote=FALSE, sep="\t", row.names = FALSE)

object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_10samples.txt",  pca = TRUE , plot = FALSE)
biplot(object, pca1, pca2, label=sample_id, color=subgroup)
object2 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('subgrouptreated_female - subgroupcontrol_female'), plot = FALSE)

fdata1 <- data.frame(fdt(object2))
fdata1_pval=fdata1[fdata1[6] <=0.05,]
nrow(fdata1_pval)
fdata1_fdr=fdata1[fdata1[7] <=0.05,]
nrow(fdata1_fdr)
write.csv(fdata1_fdr,"/Users/shahina/Projects/20-1JOHO-001/results/treated_control_F_after_excluding_10samples.csv")

p4 <- ggplot(fdata1, aes(x = p.subgrouptreated_female...subgroupcontrol_female.limma)) + 
  geom_histogram(colour = 4, fill = "white") +
  labs(x = "p.value", title = paste0("Females 10 Samples Excluded: Pvalues(<=0.05) =", nrow(fdata1_pval)," genes and FDR(<0.05) =",nrow(fdata1_fdr)," genes"))

#Female exclude 11 samples
DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt", head=TRUE)
#apart from marker set1 samples we had to also remove other samples which were inter mixing treated_female_R25,control_female_R44,control_female_R46,control_female_R52, treated_female_R45,treated_female_R43
#control_female_R41,control_female_R58,treated_female_R31,treated_female_R26,treated_female_R35,treated_female_R33,treated_female_R53,treated_female_R25,control_female_R44,control_female_R46,control_female_R52,treated_female_R45,treated_female_R43
DF1 <- subset(DF, select=-c(control_female_R41,control_female_R58,control_female_R44,control_female_R52,control_female_R46,treated_female_R31,treated_female_R35,treated_female_R26,treated_female_R33,treated_female_R25,treated_female_R45))
write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_11samples.txt", quote=FALSE, sep="\t", row.names = FALSE)

object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_11samples.txt",  pca = TRUE , plot = FALSE)
biplot(object, pca1, pca2, label=sample_id, color=subgroup)
object2 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('subgrouptreated_female - subgroupcontrol_female'), plot = FALSE)

fdata1 <- data.frame(fdt(object2))
fdata1_pval=fdata1[fdata1[6] <=0.05,]
nrow(fdata1_pval)
fdata1_fdr=fdata1[fdata1[7] <=0.05,]
nrow(fdata1_fdr)

p5 <- ggplot(fdata1, aes(x = p.subgrouptreated_female...subgroupcontrol_female.limma)) + 
  geom_histogram(colour = 4, fill = "white") +
  labs(x = "p.value", title = paste0("Females 11 Samples Excluded: Pvalues(<=0.05) =", nrow(fdata1_pval)," genes and FDR(<0.05) =",nrow(fdata1_fdr)," genes"))


#Female exclude 13 samples
DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt", head=TRUE)
#apart from marker set1 samples we had to also remove other samples which were inter mixing treated_female_R25,control_female_R44,control_female_R46,control_female_R52, treated_female_R45,treated_female_R43
#control_female_R41,control_female_R58,treated_female_R31,treated_female_R26,treated_female_R35,treated_female_R33,treated_female_R53,treated_female_R25,control_female_R44,control_female_R46,control_female_R52,treated_female_R45,treated_female_R43
DF1 <- subset(DF, select=-c(control_female_R41,control_female_R58,control_female_R44,control_female_R52,control_female_R46,treated_female_R31,treated_female_R35,treated_female_R26,treated_female_R33,treated_female_R25,treated_female_R45,treated_female_R43,treated_female_R53))
write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_13samples.txt", quote=FALSE, sep="\t", row.names = FALSE)

object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_13samples.txt",  pca = TRUE , plot = FALSE)
biplot(object, pca1, pca2, label=sample_id, color=subgroup)
object2 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('subgrouptreated_female - subgroupcontrol_female'), plot = FALSE)

fdata1 <- data.frame(fdt(object2))
fdata1_pval=fdata1[fdata1[6] <=0.05,]
nrow(fdata1_pval)
fdata1_fdr=fdata1[fdata1[7] <=0.05,]
nrow(fdata1_fdr)

p6 <- ggplot(fdata1, aes(x = p.subgrouptreated_female...subgroupcontrol_female.limma)) + 
  geom_histogram(colour = 4, fill = "white") +
  labs(x = "p.value", title = paste0("Females 13 Samples Excluded: Pvalues(<=0.05) =", nrow(fdata1_pval)," genes and FDR(<0.05) =",nrow(fdata1_fdr)," genes"))


png("/Users/shahina/Projects/20-1JOHO-001/plots/histograms_for_feamle.png", height=1500, width=900, res=100)
ggpubr::ggarrange(p1, p2,p3,p4,p5,p6,
                  ncol = 1, nrow = 6)
dev.off()
