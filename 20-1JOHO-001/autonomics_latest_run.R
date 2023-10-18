library("autonomics")
library("magrittr")
library("biomaRt")
library("org.Rn.eg.db")


setwd("/Users/shahina/Projects/20-1JOHO-001")
res <- read.table("20-1JOHO-001_htseq_counts.txt", head=TRUE)
#Contrasts
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


write.table(res, "/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_htseq_counts_treated_control_40_male_female.txt", sep="\t", quote=FALSE,  row.names=FALSE)


res_treated_and_control_male <- data.frame(res[1], res[grep("treated_male",names(res))], res[grep("control_male",names(res))])
write.table(res_treated_and_control_male, "/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_htseq_counts_treated_control_20_male.txt", sep="\t", quote=FALSE,  row.names=FALSE)

res_treated_and_control_female <- data.frame(res[1], res[grep("treated_female",names(res))], res[grep("control_female",names(res))])
write.table(res_treated_and_control_female, "/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_htseq_counts_treated_control_20_female.txt", sep="\t", quote=FALSE,  row.names=FALSE)


#####################
#ANALYSIS FOR MALES
#####################
#run autonomics on 20 male samples
object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_htseq_counts_treated_control_20_male.txt",pca=TRUE, plot = FALSE)
object$subgroup <- as.factor(c("treated","treated","treated","treated","treated","treated","treated","treated","treated","treated","treated",
                               "control","control","control","control","control","control","control","control","control"))

pdf("/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_20male_samples.pdf", width=10)
  biplot(object, pca1, pca2,color=subgroup)
dev.off()

object1 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('treated - control'), plot = FALSE)

fdata(object1) %<>% cbind(limma(object1))
fdata1_select <- fdata(object1)[c("feature_name","treated - control.effect","treated - control.p","treated - control.fdr")]
fdata1_pval=fdata1_select[fdata1_select[3] <=0.05,]
names(fdata1_pval) <- c("gene_name","effects","pvalue", "fdr")

write.csv(fdata1_pval, "/Users/shahina/Projects/20-1JOHO-001/latest_analysis/DEG_20male_samples_treated_vs_control.csv")


#After excluding 5 samples from 20 samples
#Excluded samples
#control_male_R56
#control_male_R59
#treated_male_R28
#treated_male_R40
#treated_male_R63

object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_htseq_counts_treated_control_20_male.txt",pca=TRUE, plot = FALSE)
object$subgroup <- as.factor(c("treated","treated","treated","treated","treated","treated","treated","treated","treated","treated","treated",
                               "control","control","control","control","control","control","control","control","control"))
#drop samples
object <- object %>% filter_samples(!sample_id %in% c("control_male_R56","control_male_R59","treated_male_R28","treated_male_R40","treated_male_R63"))

pdf("/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_15male_samples.pdf", width=10)
 biplot(object, pca1, pca2,label=sample_id,color=subgroup)
dev.off()

object1 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('treated - control'), plot = FALSE)

fdata(object1) %<>% cbind(limma(object1))
fdata1_select <- fdata(object1)[c("feature_name","treated - control.effect","treated - control.p","treated - control.fdr")]
fdata1_pval=fdata1_select[fdata1_select[3] <=0.05,]
names(fdata1_pval) <- c("gene_name","effects","pvalue", "fdr")
write.csv(fdata1_pval, "/Users/shahina/Projects/20-1JOHO-001/latest_analysis/DEG_15male_samples_treated_vs_control.csv")

#####################
#ANALYSIS FOR FEMALES
#####################
#run autonomics on 20 male samples
object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_htseq_counts_treated_control_20_female.txt",pca=TRUE, plot = TRUE)
object$subgroup <- as.factor(c("treated","treated","treated","treated","treated","treated","treated","treated","treated","treated","treated",
                               "control","control","control","control","control","control","control","control","control"))

pdf("/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_20female_samples.pdf", width=10)
  biplot(object, pca1, pca2,color=subgroup)
dev.off()

object1 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('treated - control'), plot = FALSE)

fdata(object1) %<>% cbind(limma(object1))
fdata1_select <- fdata(object1)[c("feature_name","treated - control.effect","treated - control.p","treated - control.fdr")]
fdata1_pval=fdata1_select[fdata1_select[3] <=0.05,]
names(fdata1_pval) <- c("gene_name","effects","pvalue", "fdr")

write.csv(fdata1_pval, "/Users/shahina/Projects/20-1JOHO-001/latest_analysis/DEG_20female_samples_treated_vs_control.csv")


################################
#ANALYSIS FOR FEMALES AND MALES
################################

object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_htseq_counts_treated_control_40_male_female.txt",pca=TRUE, plot = TRUE)
#object$subgroup <- as.factor(c("treated","treated","control","control","control","treated","control","treated","control","treated","control",
#                               "control","control","control","treated","control","control","treated","control","treated","control","treated","treated",
#                              "treated","treated","treated","control", "treated","treated","treated","control","treated","control","control","treated","control","treated","treated","treated"))


pdf("/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_40male_female_samples.pdf", width=10)
  biplot(object, pca1, pca2,color=subgroup)
dev.off()

object$subgroup <- as.factor(c("treated","treated","control","treated_male","control","control","treated","control","treated","control","treated","control",
                               "control","control","control","treated","control","control","treated","control","treated","control","treated","treated",
                              "treated","treated","treated","control", "treated","treated","treated","control","treated","control","control","treated","control","treated","treated","treated"))

object1 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('treated - control'), plot = FALSE)

fdata(object1) %<>% cbind(limma(object1))
fdata1_select <- fdata(object1)[c("feature_name","treated - control.effect","treated - control.p","treated - control.fdr")]
fdata1_pval=fdata1_select[fdata1_select[3] <=0.05,]
names(fdata1_pval) <- c("gene_name","effects","pvalue", "fdr")

write.csv(fdata1_pval, "/Users/shahina/Projects/20-1JOHO-001/latest_analysis/DEG_40male_female_samples_treated_vs_control.csv")


##########
#JUNK CODE
##########
#CALCULATE cpm for 15 males
object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_htseq_counts_treated_control_20_male.txt",pca=FALSE, plot = FALSE, cpm=FALSE)
object$subgroup <- as.factor(c("treated","treated","treated","treated","treated","treated","treated","treated","treated","treated","treated",
                               "control","control","control","control","control","control","control","control","control"))
#drop samples
object <- object %>% filter_samples(!sample_id %in% c("control_male_R56","control_male_R59","treated_male_R28","treated_male_R40","treated_male_R63"))

library(edgeR)
## as DGEList
dge <- DGEList(counts=counts(object))
## calculate norm. factors
dge <- calcNormFactors(dge, method="TMM")
## get normalized counts
normalized.counts <- cpm(dge)
normalized.counts1 <- normalized.counts[rownames(normalized.counts) == "Penk",]

write.csv(normalized.counts1, "/Users/shahina/Projects/20-1JOHO-001/penk_cpm.csv")


#libsize <- scaledlibsizes(values(object))

#cpm <- counts2cpm(counts(object))

#cpm[rownames(cpm) == "Penk",]


