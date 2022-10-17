library(ggplot2)
res <- read.csv("/Users/shahina/Projects/20-1JOHO-001/results/treated_and_control_male_after_5samples_removed.csv")
res1 <- as.data.frame(res)

#assign up and down regulation and non signif based on log2fc
res1$direction <- ifelse(res1$effects < -0.5, "down_regulated", 
                         ifelse(res1$effects > 0.5, "up_regulated", "signif" ))

png("/Users/shahina/Projects/20-1JOHO-001/plots/Volcano_plot_0.5log2FC.png", width=1300, height=500, res=120)
ggplot(res1, aes(effects, -log10(fdr))) +
  geom_point(aes(col=direction),
             size=0.5,
             show.legend = FALSE) +
  scale_color_manual(values=c("blue", "gray", "red")) +
  theme(axis.text.x = element_text(size=11),
        axis.text.y = element_text(size=11),
        text = element_text(size=11)) +
  annotate("text",x=2.2,y=1.7,hjust = 0,label=" Total (FDR <=0.05) = 6678 \n Total Upregulated = 3138 \n Total Down Regulated = 3540 \n Log2FC > 1 = 120 \n Log2FC < -1 = 90", size = 3)  +
  xlab("log2(FC)") +
  ylab("-log10(FDR)") 
  
dev.off()
