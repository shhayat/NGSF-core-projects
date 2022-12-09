library(autonomics)
library(magrittr)


object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/21-1JOHO-001/expression/feature_counts.txt",pca=TRUE, plot = FALSE)
object$subgroup <- as.factor(c("control","treated","treated","treated","control","control"))

pdf("/Users/shahina/Projects/21-1JOHO-001/PCA_before_sample_removal.pdf", width=10)
biplot(object, pca1, pca2,color=subgroup, label =sample_id)
dev.off()

object <- object %>% filter_samples(!sample_id %in% c("control_R79","treated_R78"))

pdf("/Users/shahina/Projects/21-1JOHO-001/PCA_after_sample_removal.pdf", width=10)
biplot(object, pca1, pca2,color=subgroup, label =sample_id)
dev.off()


object2 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('subgrouptreated - subgroupcontrol'), plot = TRUE)

fdata1 <- data.frame(fdt(object2))
fdata1_select <- fdata1[c(2,5,6,7)]
fdata1_pval=fdata1_select[fdata1_select[3] <=0.05,]
names(fdata1_pval) <- c("gene_name","effects","pvalue", "fdr")
fdata1_pval_order <- fdata1_pval[order(fdata1_pval$pvalue),]

#NROW(fdata1_pval)
#1427
fdata1_fdr=fdata1_select[fdata1_select[4] <=0.05,]
names(fdata1_fdr) <- c("gene_name","effects","pvalue", "fdr")
fdata1_fdr_order <- fdata1_fdr[order(fdata1_fdr$fdr),]
#NROW(fdata1_fdr)
#[1] 0

fdata1_pval_order$GeneID <- mapIds(org.Rn.eg.db, keys=fdata1_pval_order$gene_name, column="ENSEMBL", keytype="SYMBOL", multiVals="first")

fdata1_pval_order <- fdata1_pval_order[c(5,1:4)]
write.csv(fdata1_pval_order, "/Users/shahina/Projects/21-1JOHO-001/DEG_2_treated_vs_2_control_at_pval0.05.csv")
