library(ggplot2)
library(ggrepel)

#using 15male samples @ fdr 0.05
res <- read.csv("/Users/shahina/Projects/20-1JOHO-001/latest_analysis/DEG_15male_samples_treated_vs_control_at_fdr0.05.csv")
res1 <- as.data.frame(res)

res1$direction <- ifelse(as.numeric(res1$effects) <= -0.6, "down_regulated", 
                            ifelse(as.numeric(res1$effects) >= 0.6, "up_regulated", "non_signif" ))

pdf("/Users/shahina/Projects/20-1JOHO-001/latest_analysis/Volcano_plot_at_FDR0.05.pdf")
p <- ggplot(res1, aes(as.numeric(effects), -log10(as.numeric(fdr)))) +
  geom_point(aes(col=direction),size=0.4,show.legend = FALSE) +
  scale_color_manual(values=c("blue", "gray", "red")) +
  theme(axis.text.x = element_text(size=11),
        axis.text.y = element_text(size=11),
        text = element_text(size=11)) +
  xlab("log2(FC)") +
  ylab("-log10(FDR)") 

#order up and down on lowest adj pvalue
up <- res1[res1$direction == "up_regulated",]
up_ordered <- up[order(up$fdr),]
down <- res1[res1$direction == "down_regulated",]
down_ordered <- down[order(down$fdr),]

p1 <- p + geom_text_repel(data=head(up_ordered,10),aes(label=gene_name),size=2, box.padding = unit(0.7, "lines"), max.overlaps = Inf)
p2 <- p1 + geom_text_repel(data=head(down_ordered,10),aes(label=gene_name),size=2, box.padding = unit(0.7, "lines"), max.overlaps = Inf)
print(p2)
dev.off()




#using male samples @ fdr 0.05 and log2FC 0.6

res <- read.csv("/Users/shahina/Projects/20-1JOHO-001/latest_analysis/DEG_15male_samples_treated_vs_control_at_fdr0.05_and_log2FC0.6.csv")
res1 <- as.data.frame(res)

res1$direction <- ifelse(as.numeric(res1$effects) <= -0.6, "down_regulated", 
                            ifelse(as.numeric(res1$effects) >= 0.6, "up_regulated", "non_signif" ))

pdf("/Users/shahina/Projects/20-1JOHO-001/latest_analysis/Volcano_plot_at_FDR0.05_and_Log2FC0.6.pdf")
p <- ggplot(res1, aes(as.numeric(effects), -log10(as.numeric(fdr)))) +
  geom_point(aes(col=direction),size=0.4,show.legend = FALSE) +
  scale_color_manual(values=c("blue", "gray", "red")) +
  theme(axis.text.x = element_text(size=11),
        axis.text.y = element_text(size=11),
        text = element_text(size=11)) +
  xlab("log2(FC)") +
  ylab("-log10(FDR)") 

#order up and down on lowest adj pvalue
up <- res1[res1$direction == "up_regulated",]
up_ordered <- up[order(up$fdr),]
down <- res1[res1$direction == "down_regulated",]
down_ordered <- down[order(down$fdr),]

p1 <- p + geom_text_repel(data=head(up_ordered,10),aes(label=gene_name),size=2, box.padding = unit(0.7, "lines"), max.overlaps = Inf)
p2 <- p1 + geom_text_repel(data=head(down_ordered,10),aes(label=gene_name),size=2, box.padding = unit(0.7, "lines"), max.overlaps = Inf)
print(p2)
dev.off()
