library("autonomics")
library("magrittr")
library("ggplot2")
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


write.table(res,"/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_htseq_counts_treated_control_40_male_female.txt", sep="\t", quote=FALSE,  row.names=FALSE)

res_treated_and_control_male <- data.frame(res[1], res[grep("treated_male",names(res))], res[grep("control_male",names(res))])
write.table(res_treated_and_control_male, "/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_htseq_counts_treated_control_20_male.txt", sep="\t", quote=FALSE,  row.names=FALSE)


res_treated_and_control_female <- data.frame(res[1], res[grep("treated_female",names(res))], res[grep("control_female",names(res))])
write.table(res_treated_and_control_female, "/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_htseq_counts_treated_control_20_female.txt", sep="\t", quote=FALSE,  row.names=FALSE)


#run autonomics on 20 male samples
object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_htseq_counts_treated_control_20_male.txt",pca=TRUE, plot = FALSE)
object$subgroup <- as.factor(c("treated","treated","treated","treated","treated","treated","treated","treated","treated","treated","treated",
                               "control","control","control","control","control","control","control","control","control"))

#tiff("/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_20male_samples.tif")
#biplot(object, pca1, pca2, label=sample_id,color=subgroup) + ggtitle("All 20 males")
biplot(object, pca1, pca2,color=subgroup) + ggtitle("All 20 males")

#dev.off()

object1 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('treated - control'), plot = TRUE)

fdata1 <- data.frame(fdt(object1))
fdata1_select <- fdata1[c(2,5,6,7)]
fdata1_pval=fdata1_select[fdata1_select[3] <=0.05,]
#NROW(fdata1_pval)
#[1] 2101
names(fdata1_pval) <- c("gene_name","effects","pvalue", "fdr")

#NROW(fdata1_select[fdata1_select[4] <=0.05,])
#[1] 0
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

tiff("/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_15male_samples.tiff", width = 10, height = 10, units = 'in', res = 500)
#pdf("/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_15male_samples.pdf", width=10)
biplot(object, pca1, pca2,color=subgroup, fixed = list(shape = 15, size = 5)) +
    ggtitle("Males") +
    theme(axis.text=element_text(size=40), 
        axis.title=element_text(size=25,face="bold"),
        legend.text = element_text(size=20), 
        legend.title = element_text(size=20,face="bold"),
        plot.title = element_text(size=25,face="bold",hjust = 0.5),
        panel.grid.major = element_line(color = "dark gray"),
        panel.grid.minor = element_line(color = "dark gray"))
dev.off()

object2 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('subgrouptreated - subgroupcontrol'), plot = TRUE)

fdata1 <- data.frame(fdt(object2))
fdata1_select <- fdata1[c(2,5,6,7)]
fdata1_pval=fdata1_select[fdata1_select[3] <=0.05,]
#NROW(fdata1_pval)
names(fdata1_pval) <- c("gene_name","effects","pvalue", "fdr")
#[1] 7966
fdata1_fdr=fdata1_select[fdata1_select[4] <=0.05,]
names(fdata1_fdr) <- c("gene_name","effects","pvalue", "fdr")
fdata1_fdr_order <- fdata1_fdr[order(fdata1_fdr$fdr),]
#NROW(fdata1_fdr)
#[1] 6660
write.csv(fdata1_fdr_order, "/Users/shahina/Projects/20-1JOHO-001/latest_analysis/DEG_15male_samples_treated_vs_control_at_fdr0.05.csv")


#####################
#ANALYSIS FOR FEMALES
#####################
#run autonomics on 20 female samples
object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_htseq_counts_treated_control_20_female.txt",pca=TRUE, plot = FALSE)
object$subgroup <- as.factor(c("treated","treated","treated","treated","treated","treated","treated","treated","treated","treated","treated",
                               "control","control","control","control","control","control","control","control","control"))

#pdf("/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_20female_samples.pdf", width=10)
biplot(object, pca1, pca2,color=subgroup) + ggtitle("All 20 Females")
#dev.off()

object1 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('treated - control'), plot = FALSE)
fdata(object1) %<>% cbind(limma(object1))
fdata1_select <- fdata(object1)[c("feature_name","treated - control.effect","treated - control.p","treated - control.fdr")]
fdata1_pval=fdata1_select[fdata1_select[3] <=0.05,]
names(fdata1_pval) <- c("gene_name","effects","pvalue", "fdr")
write.csv(fdata1_pval, "/Users/shahina/Projects/20-1JOHO-001/latest_analysis/DEG_20female_samples_treated_vs_control.csv")




#################################
#ANALYSIS FOR FEMALES AND MALE
#################################

#run autonomics on male and female samples
object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_htseq_counts_treated_control_40_male_female.txt",pca=TRUE, plot = FALSE)

biplot(object, pca1, pca2,color=subgroup) + ggtitle("All 40 Samples (20 Males and 20 Females)")

object1 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('treated - control'), plot = FALSE)
fdata(object1) %<>% cbind(limma(object1))
fdata1_select <- fdata(object1)[c("feature_name","treated - control.effect","treated - control.p","treated - control.fdr")]
fdata1_pval=fdata1_select[fdata1_select[3] <=0.05,]
names(fdata1_pval) <- c("gene_name","effects","pvalue", "fdr")
write.csv(fdata1_pval, "/Users/shahina/Projects/20-1JOHO-001/latest_analysis/DEG_40male_female_samples_treated_vs_control.csv")
