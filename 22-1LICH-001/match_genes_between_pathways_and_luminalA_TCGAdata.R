setwd("Desktop/TCGA_analysis_for_pathways/")
library("readxl")


luminalA <- read.csv("LuminalA_vs_Normal.csv", header=TRUE)[c(1,3:4,7:10)] 
colnames(luminalA) <- c("Gene","Mean Log2 BRCA_LumA","Mean Log2 BRCA_Normal","Log2 Ratio","pvalue","qvalue","Higher Expression in")

luminalA <- luminalA[luminalA$pvalue <= 0.05,]
#cAMP mediated Signaling
A3A_p1 <- read_excel("A3A_cAMP_Mediated_Signaling.xls")[1]
colnames(A3A_p1) <- c("Gene")
A3B_p1 <- read_excel("A3B_cAMP_Mediated_Signaling.xls")[1]
colnames(A3B_p1) <- c("Gene")
A3H_p1 <- read_excel("A3H_cAMP_Mediated_Signaling.xls")[1]
colnames(A3H_p1) <- c("Gene")

#3
A3A_p11 <-  merge(luminalA, A3A_p1, by = "Gene")
#8
A3B_p11 <-  merge(luminalA, A3B_p1, by = "Gene")
#12
A3H_p11 <-  merge(luminalA, A3H_p1, by = "Gene")

pairwise_A3A <- read.csv("A3A_Pairwise Analysis  genes_fc2_pv05.csv")[2:3]
pairwise_A3A_p1 <- merge(A3A_p11,pairwise_A3A, by="Gene")

pairwise_A3B <- read.csv("A3B_Pairwise Analysis  genes_fc2_pv05.csv")[2:3]
pairwise_A3B_p1 <- merge(A3B_p11,pairwise_A3B, by="Gene")

pairwise_A3H <- read.csv("A3H_Pairwise Analysis  genes_fc2_pv05.csv")[2:3]
pairwise_A3H_p1 <- merge(A3H_p11,pairwise_A3H, by="Gene")

write.csv(pairwise_A3A_p1,"pairwise_A3A_camp_mediated_signaling.csv", row.names = FALSE)
write.csv(pairwise_A3B_p1,"pairwise_A3B_camp_mediated_signaling.csv", row.names = FALSE)
write.csv(pairwise_A3H_p1,"pairwise_A3H_camp_mediated_signaling.csv", row.names = FALSE)



#Pulmonary Healing Signaling pathway
A3A_p2 <- read_excel("A3A_Pulmonary_Healing_Signaling_pathway.xls")[1]
colnames(A3A_p2) <- c("Gene")
A3B_p2 <- read_excel("A3B_Pulmonary_Healing_Signaling_pathway.xls")[1]
colnames(A3B_p2) <- c("Gene")
A3H_p2 <- read_excel("A3H_Pulmonary_Healing_Signaling_pathway.xls")[1]
colnames(A3H_p2) <- c("Gene")
#4
A3A_p22 <-  merge(luminalA, A3A_p2, by = "Gene")
#5
A3B_p22 <-  merge(luminalA, A3B_p2, by = "Gene")
#4
A3H_p22 <-  merge(luminalA, A3H_p2, by = "Gene")

pairwise_A3A <- read.csv("A3A_Pairwise Analysis  genes_fc2_pv05.csv")[2:3]
pairwise_A3A_p2 <- merge(A3A_p22,pairwise_A3A, by="Gene")

pairwise_A3B <- read.csv("A3B_Pairwise Analysis  genes_fc2_pv05.csv")[2:3]
pairwise_A3B_p2 <- merge(A3B_p22,pairwise_A3B, by="Gene")

pairwise_A3H <- read.csv("A3H_Pairwise Analysis  genes_fc2_pv05.csv")[2:3]
pairwise_A3H_p2 <- merge(A3H_p22,pairwise_A3H, by="Gene")

write.csv(pairwise_A3A_p2,"pairwise_A3A_pulmonary_healing_signaling.csv", row.names = FALSE)
write.csv(pairwise_A3B_p2,"pairwise_A3B_pulmonary_healing_signaling.csv", row.names = FALSE)
write.csv(pairwise_A3H_p2,"pairwise_A3H_pulmonary_healing_signaling.csv", row.names = FALSE)
