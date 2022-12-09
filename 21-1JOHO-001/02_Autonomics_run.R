library(autonomics)
library(magrittr)

object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/21-1JOHO-001/expression/feature_counts.txt",pca=TRUE, plot = FALSE)
object$subgroup <- as.factor(c("control","treated","treated","treated","control","control"))
object <- object %>% filter_samples(!sample_id %in% c("control_male_R56","control_male_R59","treated_male_R28","treated_male_R40","treated_male_R63"))

pdf("/Users/shahina/Projects/20-1JOHO-001/latest_analysis/20-1JOHO-001_15male_samples.pdf", width=10)
biplot(object, pca1, pca2,color=subgroup)
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

fdata1_fdr_order$GeneID <- mapIds(org.Rn.eg.db, keys=fdata1_fdr_order$gene_name, column="ENSEMBL", keytype="SYMBOL", multiVals="first")

fdata1_fdr_order <- fdata1_fdr_order[c(5,1:4)]
write.csv(fdata1_fdr_order, "/Users/shahina/Projects/20-1JOHO-001/latest_analysis/DEG_15male_samples_treated_vs_control_at_fdr0.05.csv")
