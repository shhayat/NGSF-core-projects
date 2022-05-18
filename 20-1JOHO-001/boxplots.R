
  
#####################
#BOX PLOT FOR PENK
#####################

pdf("/Users/shahina/Projects/20-1JOHO-001/plots/boxplot_males.pdf")
  object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_M.txt", plot = FALSE, cpm=TRUE, log2 = TRUE)
  object <- filter_features(object,   feature_name=='Penk',  verbose = TRUE)
  p1 <- plot_subgroup_boxplots(object, subgroup=subgroup, jitter = FALSE) + ggplot2::ggtitle("All samples included")

  #round1
  DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_M.txt", head=TRUE)
  DF1 <- subset(DF, select=-c(control_male_R61,control_male_R59,control_male_R56,treated_male_R63,treated_male_R40,treated_male_R28))  
  write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_M_samples_excluded_round1.txt", quote=FALSE, sep="\t", row.names = FALSE)

  object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_M_samples_excluded_round1.txt", plot = FALSE, cpm=TRUE, log2 = TRUE)
  object <- filter_features(object,   feature_name=='Penk',  verbose = TRUE)
  p2 <- plot_subgroup_boxplots(object, subgroup=subgroup, jitter = FALSE) + ggplot2::ggtitle("Round 1")

  #round1+2
  #exclude male samples round1+2
  DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_M.txt", head=TRUE)
  DF1 <- subset(DF, select=-c(control_male_R61,control_male_R59,control_male_R56,treated_male_R63,treated_male_R40,treated_male_R28,treated_male_R55,treated_male_R64))  
  write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_M_samples_excluded_round1+2.txt", quote=FALSE, sep="\t", row.names = FALSE)

  object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_M_samples_excluded_round1+2.txt", plot = FALSE, cpm=TRUE, log2 = TRUE)
  object <- filter_features(object,   feature_name=='Penk',  verbose = TRUE)
  p3 <- plot_subgroup_boxplots(object, subgroup=subgroup, jitter = FALSE) + ggplot2::ggtitle("Round 1+2")

  ggpubr::ggarrange(p1, p2, p3,ncol = 2, nrow = 2)
dev.off()

pdf("/Users/shahina/Projects/20-1JOHO-001/plots/boxplot_females.pdf")
  object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt", plot = FALSE, cpm=TRUE, log2 = TRUE)
  object <- filter_features(object,   feature_name=='Penk',  verbose = TRUE)
  p1 <- plot_subgroup_boxplots(object, subgroup=subgroup, jitter = FALSE) + ggplot2::ggtitle("All samples included")

  #round1
  DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt", head=TRUE,, cpm=TRUE, log2 = TRUE)
  DF1 <- subset(DF, select=-c(control_female_R41,control_female_R58,treated_female_R31,treated_female_R26,treated_female_R35,treated_female_R33))  
  write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_round1.txt", quote=FALSE, sep="\t", row.names = FALSE)

  object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_round1.txt", plot = FALSE, cpm=TRUE, log2 = TRUE)
  object <- filter_features(object,   feature_name=='Penk',  verbose = TRUE)
  p2 <- plot_subgroup_boxplots(object, subgroup=subgroup, jitter = FALSE) + ggplot2::ggtitle("Round 1")

  #round1+2
  DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt", head=TRUE)
  DF1 <- subset(DF, select=-c(control_female_R41,control_female_R58,treated_female_R31,treated_female_R26,treated_female_R35,treated_female_R33,treated_female_R53))  
  write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_round1+2.txt", quote=FALSE, sep="\t", row.names = FALSE)

  object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_round1+2.txt", plot = FALSE, cpm=TRUE, log2 = TRUE)
  object <- filter_features(object,   feature_name=='Penk',  verbose = TRUE)
  p3 <- plot_subgroup_boxplots(object, subgroup=subgroup, jitter = FALSE) + ggplot2::ggtitle("Round 1+2")

  #round1+2+3
  DF <- read.table("/Users/shahina/Projects/20-1JOHO-001/20-1JOHO-001_htseq_counts_treated_control_F.txt", head=TRUE)
  DF1 <- subset(DF, select=-c(control_female_R41,control_female_R58,treated_female_R31,treated_female_R26,treated_female_R35,treated_female_R33,treated_female_R53,treated_female_R49))  
  write.table(DF1,"/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_round1+2+3.txt", quote=FALSE, sep="\t", row.names = FALSE)

  object <-  read_rnaseq_counts(file ="/Users/shahina/Projects/20-1JOHO-001/treated_control_F_samples_excluded_round1+2+3.txt", plot = FALSE, cpm=TRUE, log2 = TRUE)
  object <- filter_features(object,   feature_name=='Penk',  verbose = TRUE)
  p4 <- plot_subgroup_boxplots(object, subgroup=subgroup, jitter = FALSE) + ggplot2::ggtitle("Round 1+2+3")

  ggpubr::ggarrange(p1, p2, p3,p4, ncol = 2, nrow = 2)
dev.off()
