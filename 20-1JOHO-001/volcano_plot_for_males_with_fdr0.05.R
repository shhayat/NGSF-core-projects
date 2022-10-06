library(ggplot2)
library(ggrepel)

res <- read.csv("/datastore/NGSF001/projects/20-1JOHO-001/dge_males_fdr0.05.txt")
res1 <- as.data.frame(res)

res <- read.table("dge_males_fdr0.05.txt", header=TRUE)
res1 <- as.data.frame(res)

res1$direction <- ifelse(as.numeric(res1$effects) < -1, "down_regulated", 
                            ifelse(as.numeric(res1$effects) > 1, "up_regulated", "signif" ))

pdf("Volcano_plot_fdr0.05_and_log2FC_3.pdf")
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

