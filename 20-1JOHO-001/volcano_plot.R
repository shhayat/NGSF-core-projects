res <- read.csv("/Users/shahina/Projects/20-1JOHO-001/results/treated_and_control_male_after_5samples_removed.csv")
res1 <- as.data.frame(res)
#rm row with symbol = NA these are pseudogenes
res1 <- subset(res1,!symbol == "NA")
#assign up and down regulation and non signif based on log2fc
res1$direction <- ifelse(res1$log2FoldChange < -0.5, "down_reg", 
                               ifelse(res1$log2FoldChange > 0.5, "up_reg", "not_signf" ))

pdf("Volcano_plot.pdf")
                ggplot(res1, aes(log2FoldChange, -log10(pvalue))) +
                geom_point(aes(col=direction),
                               size=0.7,
                               show.legend = FALSE) +
                scale_color_manual(values=c("blue", "black", "green")) +
                theme(axis.text.x = element_text(size=16),
                      axis.text.y = element_text(size=16),
                      text = element_text(size=16))
dev.off()
