
#For performing analysis following steps were followed.
#1. LuminalA vs Normal Data was extracted from cioportal webpage (LuminalA_vs_Normal_from_cbioportal.csv)
#(For extracting data Breast Invasive Carcinoma(TCGA, pancancer altas) data study was selected click on 
#explore selected study. From Subtype select Luminal A and Normal patient data, click on compare groups and 
#select mRNA from next page.)
#2. Extracted genes involved in cAMP mediated signaling and Pulmonary healing signaling for each condition
#3. Matched genes LuminalA vs Normal Data to pathways extracted in step2 (Folder: pathways_used_from_IPA)
#4. Extracted original significant gene list sent by Linda (Folder: significant_pairwise_gene_list)
#5. Checked the directionality of genes from step3 to significant genes from step4  (Folder: results)

setwd("~/Desktop/core-projects/22-LICH-001/TCGA_analysis_for_pathways/")
library("readxl")
library("WriteXLS")
#LuminalA_vs_Normal extracted from cbioPortal
luminalA <- read.csv("LuminalA_vs_Normal_from_cbioportal.csv", header=TRUE)[c(1,3:4,7:10)] 
colnames(luminalA) <- c("Gene","Mean Log2 BRCA_LumA","Mean Log2 BRCA_Normal","Log2 Ratio","pvalue","qvalue","Higher Expression in")

luminalA <- luminalA[luminalA$pvalue <= 0.05,]
#cAMP mediated Signaling
A3A_p1 <- read_excel("pathways_used_for_analysis/A3A_cAMP_Mediated_Signaling.xls")[1]
colnames(A3A_p1) <- c("Gene")
A3B_p1 <- read_excel("pathways_used_for_analysis/A3B_cAMP_Mediated_Signaling.xls")[1]
colnames(A3B_p1) <- c("Gene")
A3H_p1 <- read_excel("pathways_used_for_analysis/A3H_cAMP_Mediated_Signaling.xls")[1]
colnames(A3H_p1) <- c("Gene")

#3
A3A_p11 <-  merge(luminalA, A3A_p1, by = "Gene")
#8
A3B_p11 <-  merge(luminalA, A3B_p1, by = "Gene")
#12
A3H_p11 <-  merge(luminalA, A3H_p1, by = "Gene")

pairwise_A3A <- read.csv("significant_pairwise_gene_list/A3A_Pairwise Analysis  genes_fc2_pv05.csv")[2:3]
pairwise_A3A_p1 <- merge(A3A_p11,pairwise_A3A, by="Gene")

pairwise_A3B <- read.csv("significant_pairwise_gene_list/A3B_Pairwise Analysis  genes_fc2_pv05.csv")[2:3]
pairwise_A3B_p1 <- merge(A3B_p11,pairwise_A3B, by="Gene")

pairwise_A3H <- read.csv("significant_pairwise_gene_list/A3H_Pairwise Analysis  genes_fc2_pv05.csv")[2:3]
pairwise_A3H_p1 <- merge(A3H_p11,pairwise_A3H, by="Gene")

write.csv(pairwise_A3A_p1,"results/pairwise_A3A_camp_mediated_signaling.csv", row.names = FALSE)
write.csv(pairwise_A3B_p1,"results/pairwise_A3B_camp_mediated_signaling.csv", row.names = FALSE)
write.csv(pairwise_A3H_p1,"results/pairwise_A3H_camp_mediated_signaling.csv", row.names = FALSE)



#Pulmonary Healing Signaling pathway
A3A_p2 <- read_excel("pathways_used_for_analysis/A3A_Pulmonary_Healing_Signaling_pathway.xls")[1]
colnames(A3A_p2) <- c("Gene")
A3B_p2 <- read_excel("pathways_used_for_analysis/A3B_Pulmonary_Healing_Signaling_pathway.xls")[1]
colnames(A3B_p2) <- c("Gene")
A3H_p2 <- read_excel("pathways_used_for_analysis/A3H_Pulmonary_Healing_Signaling_pathway.xls")[1]
colnames(A3H_p2) <- c("Gene")
#4
A3A_p22 <-  merge(luminalA, A3A_p2, by = "Gene")
#5
A3B_p22 <-  merge(luminalA, A3B_p2, by = "Gene")
#4
A3H_p22 <-  merge(luminalA, A3H_p2, by = "Gene")

pairwise_A3A <- read.csv("significant_pairwise_gene_list/A3A_Pairwise Analysis  genes_fc2_pv05.csv")[2:3]
pairwise_A3A_p2 <- merge(A3A_p22,pairwise_A3A, by="Gene")

pairwise_A3B <- read.csv("significant_pairwise_gene_list/A3B_Pairwise Analysis  genes_fc2_pv05.csv")[2:3]
pairwise_A3B_p2 <- merge(A3B_p22,pairwise_A3B, by="Gene")

pairwise_A3H <- read.csv("significant_pairwise_gene_list/A3H_Pairwise Analysis  genes_fc2_pv05.csv")[2:3]
pairwise_A3H_p2 <- merge(A3H_p22,pairwise_A3H, by="Gene")

write.csv(pairwise_A3A_p2,"results/pairwise_A3A_pulmonary_healing_signaling.csv", row.names = FALSE)
write.csv(pairwise_A3B_p2,"results/pairwise_A3B_pulmonary_healing_signaling.csv", row.names = FALSE)
write.csv(pairwise_A3H_p2,"results/pairwise_A3H_pulmonary_healing_signaling.csv", row.names = FALSE)





#Wound Healing Signaling Pathway
A3A_p3 <- read_excel("pathways_used_for_analysis/A3A_wound_healing_signaling_pathway.xls")[1]
colnames(A3A_p3) <- c("Gene")
A3B_p3 <- read_excel("pathways_used_for_analysis/A3B_wound_healing_signaling_pathway.xls")[1]
colnames(A3B_p3) <- c("Gene")
A3H_p3 <- read_excel("pathways_used_for_analysis/A3H_wound_healing_signaling_pathway.xls")[1]
colnames(A3H_p3) <- c("Gene")
#4
A3A_p33 <-  merge(luminalA, A3A_p3, by = "Gene")
#5
A3B_p33 <-  merge(luminalA, A3B_p3, by = "Gene")
#4
A3H_p33 <-  merge(luminalA, A3H_p3, by = "Gene")

pairwise_A3A <- read.csv("significant_pairwise_gene_list/A3A_Pairwise Analysis  genes_fc2_pv05.csv")[2:3]
pairwise_A3A_p3 <- merge(A3A_p33,pairwise_A3A, by="Gene")

pairwise_A3B <- read.csv("significant_pairwise_gene_list/A3B_Pairwise Analysis  genes_fc2_pv05.csv")[2:3]
pairwise_A3B_p3 <- merge(A3B_p33,pairwise_A3B, by="Gene")

pairwise_A3H <- read.csv("significant_pairwise_gene_list/A3H_Pairwise Analysis  genes_fc2_pv05.csv")[2:3]
pairwise_A3H_p3 <- merge(A3H_p33,pairwise_A3H, by="Gene")

WriteXLS(pairwise_A3A_p3,"results/pairwise_A3A_wound_healing_signaling.xlsx", row.names = FALSE)
WriteXLS(pairwise_A3B_p3,"results/pairwise_A3B_wound_healing_signaling.xlsx", row.names = FALSE)
WriteXLS(pairwise_A3H_p3,"results/pairwise_A3H_wound_healing_signaling.xlsx", row.names = FALSE)


