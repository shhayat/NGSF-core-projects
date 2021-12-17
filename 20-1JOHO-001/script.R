################################################
#merge htseq counts based on gene name
################################################
setwd("/datastore/NGSF001/projects/20-1JOHO-001/expression/htseq-count/stranded-reverse/")

filelist = list.files(pattern = "*.htseq.txt")
datalist <- lapply(filelist, FUN=read.table, header=FALSE)

res <- Reduce(function(x,y) {merge(x,y, by="V1")}, datalist)
res <- res[-c(1:5),]

#control male low / high , treated male low / high , control female low /hight , treated female low/high
names(res) <-c("gene_name","treated_female_low_R25","treated_female_high_R26","control_male_low_R27","treated_male_high_R28",
               "control_male_low_R29","control_female_high_R30","treated_female_high_R31","control_female_low_R32",
               "treated_female_high_R33","control_female_high_R34","treated_female_low_R35","control_male_low_R36",
               "control_male_low_R37","control_male_high_R38","control_male_low_R39","treated_male_high_R40",
               "control_female_low_R41","control_female_low_R42","treated_female_high_R43","control_female_high_R44",
               "treated_female_high_R45","control_female_high_R46","treated_male_low_R47","treated_male_high_R48",
               "treated_female_high_R49","treated_male_high_R50","treated_male_high_R51","control_female_low_R52",
               "treated_female_low_R53","treated_female_high_R54","treated_male_low_R55","control_male_low_R56",
               "treated_male_high_R57","control_female_high_R58","control_male_low_R59","treated_male_high_R60",
               "control_male_low_R61","treated_female_high_R62","treated_male_low_R63","treated_male_low_R64")

# control female, control_male, treated_male, treated_female
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


#treated female low and high, treated male low and high
res1 <- res[c(1:3, 8,10, 12, 20, 22, 26, 30, 31, 39)]
names(res1) <-c("gene_name","treated_female_low_R25","treated_female_high_R26","treated_female_high_R31",
               "treated_female_high_R33", "treated_female_low_R35", "treated_female_high_R43","treated_female_high_R45",
               "treated_female_high_R49","treated_female_low_R53","treated_female_high_R54","treated_female_high_R62")
               
#treated male low and high, treated male low and high
res1 <- res[c(1,5,17, 24,25,27,28,32,34,37,40,41)]
names(res1) <-c("gene_name","treated_male_high_R28","treated_male_high_R40","treated_male_low_R47",
                "treated_male_high_R48", "treated_male_high_R50", "treated_male_high_R51","treated_male_low_R55",
                "treated_male_high_R57","treated_male_high_R60","treated_male_low_R63","treated_male_low_R64")


#treated male low and high, treated male low and high
res1 <- res[c(1,5,17, 24,25,27,28,32,34,37,40,41)]
names(res1) <-c("gene_name","treated_male_high_R28","treated_male_high_R40","treated_male_low_R47",
                "treated_male_high_R48", "treated_male_high_R50", "treated_male_high_R51","treated_male_low_R55",
                "treated_male_high_R57","treated_male_high_R60","treated_male_low_R63","treated_male_low_R64")



#write.table(res, "/globalhome/hxo752/HPC/projects/20-1JOHO-001_htseq_counts.txt", sep="\t", quote=FALSE, , row.names=FALSE)
#write.table(res1, "/globalhome/hxo752/HPC/projects/20-1JOHO-001_htseq_counts_v1.txt", sep="\t", quote=FALSE, , row.names=FALSE)
#write.table(res1, "/globalhome/hxo752/HPC/projects/20-1JOHO-001_htseq_counts_v2.txt", sep="\t", quote=FALSE, , row.names=FALSE)
write.table(res1, "/globalhome/hxo752/HPC/projects/20-1JOHO-001_htseq_counts_v3.txt", sep="\t", quote=FALSE, , row.names=FALSE)

#library("biomaRt")
#ensembl <- useMart(host = "feb2021.archive.ensembl.org", biomart = "ENSEMBL_MART_ENSEMBL", dataset='rnorvegicus_gene_ensembl') 
#attributes = biomaRt::listAttributes(ensembl)
#ensembl <- useDataset(dataset = "rnorvegicus_gene_ensembl", mart = ensembl)
#select_attributes = biomaRt::getBM(attributes = c('ensembl_gene_id','external_gene_name','gene_biotype'), mart = ensembl)
#names(select_attributes) <- c("gene_id","gene_name","gene_biotype") 
#merged_df <- merge(select_attributes,res, by.x="gene_name", by.y="V1")


################
#RUN AUTONOMICS
################
library("autonomics")
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

#1. Male Treated - Female Treated
treated_male_female <- data.frame(res[1], res[grep("treated_male",names(res))], res[grep("treated_female",names(res))])
#2. Male Treated - Male Control
res_treated_and_control_male <- data.frame(res[1], res[grep("treated_male",names(res))], res[grep("control_male",names(res))])
#3. Female Treated - Female Control
res_treated_and_control_female <- data.frame(res[1], res[grep("treated_female",names(res))], res[grep("control_female",names(res))])


names(res) <-c("gene_name","treated_female_low_R25","treated_female_high_R26","control_male_low_R27","treated_male_high_R28",
               "control_male_low_R29","control_female_high_R30","treated_female_high_R31","control_female_low_R32",
               "treated_female_high_R33","control_female_high_R34","treated_female_low_R35","control_male_low_R36",
               "control_male_low_R37","control_male_high_R38","control_male_low_R39","treated_male_high_R40",
               "control_female_low_R41","control_female_low_R42","treated_female_high_R43","control_female_high_R44",
               "treated_female_high_R45","control_female_high_R46","treated_male_low_R47","treated_male_high_R48",
               "treated_female_high_R49","treated_male_high_R50","treated_male_high_R51","control_female_low_R52",
               "treated_female_low_R53","treated_female_high_R54","treated_male_low_R55","control_male_low_R56",
               "treated_male_high_R57","control_female_high_R58","control_male_low_R59","treated_male_high_R60",
               "control_male_low_R61","treated_female_high_R62","treated_male_low_R63","treated_male_low_R64")


#4.Male Treated High - Male Treated low
res_treated_high_low_male <- data.frame(res[1], res[grep("treated_male_low",names(res))], res[grep("treated_male_high",names(res))])
#5.Female Treated High - Female Treated low
res_treated_high_low_female <- data.frame(res[1], res[grep("treated_female_low",names(res))], res[grep("treated_female_high",names(res))])
#6.Male control High - Male control low
res_control_high_low_male <- data.frame(res[1], res[grep("control_male_low",names(res))], res[grep("control_male_high",names(res))])
#7.Female control High - Female control low
res_control_high_low_female <- data.frame(res[1], res[grep("control_female_low",names(res))], res[grep("control_female_high",names(res))])

write.table(res_treated_male_female, "/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_M_F.txt", sep="\t", quote=FALSE, , row.names=FALSE)
write.table(res_treated_and_control_male, "/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_M.txt", sep="\t", quote=FALSE, , row.names=FALSE)
write.table(res_treated_and_control_female, "/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt", sep="\t", quote=FALSE, , row.names=FALSE)

write.table(res_treated_high_low_male, "/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_high_low_M.txt", sep="\t", quote=FALSE, , row.names=FALSE)
write.table(res_treated_high_low_female, "/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_high_low_F.txt", sep="\t", quote=FALSE, , row.names=FALSE)
write.table(res_control_high_low_male, "/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_control_high_low_M.txt", sep="\t", quote=FALSE, , row.names=FALSE)
write.table(res_control_high_low_female, "/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_control_high_low_F.txt", sep="\t", quote=FALSE, , row.names=FALSE)


autonomics_read_rnaseq_counts <- function(file, contrast_name){
                                             pdf(paste0("/Users/shahina/Projects/20-1JOHO-001/results/",contrast_name,".pdf"))
                                             object <-  read_rnaseq_counts(file =file, 
                                                                            pca = TRUE, 
                                                                            fit='limma', 
                                                                            plot = TRUE)
                                             dev.off()
                                             fdata1 <- data.frame(fdata(object))
                                             fdata1_filtered_pval <- fdata1[fdata1[8] <=0.05,]
                                             fdata1_select <- fdata1_filtered_pval[c(2,6,8,10)]
                                             write.csv(fdata1_select,paste0("/Users/shahina/Projects/20-1JOHO-001/results/",contrast_name,".csv"))
                                             }                                           
autonomics_read_rnaseq_counts("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_M_F.txt","treated_male_female")
autonomics_read_rnaseq_counts("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_M.txt","treated_and_control_male")
autonomics_read_rnaseq_counts("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt", "treated_and_control_female")

autonomics_read_rnaseq_counts("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_high_low_M.txt","res_treated_high_low_male")
autonomics_read_rnaseq_counts("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_high_low_F.txt","res_treated_high_low_female")
autonomics_read_rnaseq_counts("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_control_high_low_M.txt", "res_control_high_low_male")
autonomics_read_rnaseq_counts("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_control_high_low_F.txt", "res_control_high_low_female")



object <-  read_rnaseq_counts(file =file,  pca = TRUE , plot = FALSE)

object1 <- fit_limma(object, formula = ~ 0 + subgroup, contrastdefs = c('subgrouptreated_female - subgrouptreated_male'))

is_sig(object1)
#for venn diagram
limma::vennDiagram(is_sig(object1), include=c('up','down','both'))
plot_contrast_venn(is_sig(object1))
