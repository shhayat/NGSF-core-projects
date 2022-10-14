library("autonomics")
library("magrittr")
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


res_treated_and_control_male <- data.frame(res[1], res[grep("treated_male",names(res))], res[grep("control_male",names(res))])
write.table(res_treated_and_control_male, "/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_htseq_counts_treated_control_20_male.txt", sep="\t", quote=FALSE,  row.names=FALSE)

#run autonomics on 20 male samples
object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_htseq_counts_treated_control_20_male.txt",pca=TRUE, plot = FALSE)
object$subgroup <- as.factor(c("treated","treated","treated","treated","treated","treated","treated","treated","treated","treated","treated",
                               "control","control","control","control","control","control","control","control","control"))

pdf("/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_20male_samples.pdf", width=10)
  biplot(object, pca1, pca2, label=sample_id,color=subgroup)
dev.off()

object1 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('subgrouptreated - subgroupcontrol'), plot = TRUE)

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

pdf("/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_15male_samples.pdf", width=10)
biplot(object, pca1, pca2, label=sample_id,color=subgroup)
dev.off()

object2 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('subgrouptreated - subgroupcontrol'), plot = TRUE)


fdata1 <- data.frame(fdt(object2))
fdata1_select <- fdata1[c(2,5,6,7)]
fdata1_pval=fdata1_select[fdata1_select[3] <=0.05,]
#NROW(fdata1_pval)
names(fdata1_pval) <- c("gene_name","effects","pvalue", "fdr")
#[1] 7966
fdata1_fdr=fdata1_select[fdata1_select[4] <=0.01,]
names(fdata1_fdr) <- c("gene_name","effects","pvalue", "fdr")
fdata1_fdr_order <- fdata1_fdr[order(fdata1_fdr$fdr),]
#NROW(fdata1_fdr)
#[1] 6660
write.csv(fdata1_fdr_order, "/Users/shahina/Projects/20-1JOHO-001/latest_analysis/DEG_15male_samples_treated_vs_control_at_fdr0.01.csv")

low <- fdata1_fdr_order[fdata1_fdr_order$effects <= -0.6,]
high <- fdata1_fdr_order[fdata1_fdr_order$effects >= 0.6,]
df_effect_0.6 <- rbind(low,high)
write.csv(df_effect_0.6, "/Users/shahina/Projects/20-1JOHO-001/latest_analysis/DEG_15male_samples_treated_vs_control_at_fdr0.01_and_log2FC0.6.csv")

