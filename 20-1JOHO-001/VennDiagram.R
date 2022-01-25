###############
#Venn Diagram
###############
library(autonomics)
library(eulerr)
setwd("/Users/shahina/Projects/20-1JOHO-001")
DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_M.txt", head=TRUE)
#5 SAMPLES REMOVED AFTER CHECKING THE ORIGINAL MALE PCA
DF1 <- subset(DF, select=-c(control_male_R59,control_male_R56,treated_male_R40,treated_male_R28,treated_male_R63))
write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_M_samples_excluded.txt", quote=FALSE, sep="\t", row.names = FALSE)

object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_M_samples_excluded.txt",  pca = TRUE , plot = FALSE)
biplot(object, pca1, pca2, label=sample_id, color=subgroup)
object2 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('subgrouptreated_male - subgroupcontrol_male'), plot = FALSE)

fdata1 <- data.frame(fdt(object2))
fdata1_pval_m=fdata1[fdata1[6] <=0.05,]
nrow(fdata1_pval_m)
fdata1_fdr_m=fdata1[fdata1[7] <=0.05,]
nrow(fdata1_fdr_m)

#Female exclude 10 samples
DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt", head=TRUE)
DF1 <- subset(DF, select=-c(control_female_R41,control_female_R58,control_female_R44,control_female_R52,control_female_R46,treated_female_R31,treated_female_R35,treated_female_R26,treated_female_R33,treated_female_R25))
write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_10samples.txt", quote=FALSE, sep="\t", row.names = FALSE)

object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_10samples.txt",  pca = TRUE , plot = FALSE)
biplot(object, pca1, pca2, label=sample_id, color=subgroup)
object2 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('subgrouptreated_female - subgroupcontrol_female'), plot = FALSE)

fdata1 <- data.frame(fdt(object2))
fdata1_pval_f=fdata1[fdata1[6] <=0.05,]
nrow(fdata1_pval_f)
fdata1_fdr_f=fdata1[fdata1[7] <=0.05,]
nrow(fdata1_fdr_f)


png("plots/VennDiagram_Males_Females_fdr0.05.png")
s4 <- list(Male = fdata1_fdr_m$feature_name,
           Female = fdata1_fdr_f$feature_name)

plot(euler(s4, shape = "circle"), quantities = TRUE, fill=yarrr::transparent(c('palegreen1','salmon2'), .3))
dev.off()


png("plots/VennDiagram_Males_Females_fdr0.05.png")
s1 <- list(Male = fdata1_fdr_m$feature_name,
           Female = fdata1_fdr_f$feature_name)

plot(euler(s1, shape = "circle"), quantities = TRUE, fill=yarrr::transparent(c('palegreen1','salmon2'), .2))
dev.off()

png("plots/VennDiagram_Males_fdr0.05_Females_pval0.05.png")
s2 <- list(Male = fdata1_fdr_m$feature_name,
            Female = fdata1_pval_f$feature_name)
plot(euler(s2, shape = "circle"), quantities = TRUE, fill=yarrr::transparent(c('palegreen1','salmon2'), .2))
dev.off()

