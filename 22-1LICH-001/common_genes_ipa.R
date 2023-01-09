library("readxl")

#COLLASPED
setwd("/Users/shahina/Desktop/FW_ Protein Lists for IPA - different cell line/Collapsed fork Up-Down MCF7/raw_data/")

A3A <- read_excel("A3A Collapsed fork Up-Down MCF7.xlsx")
A3B <- read_excel("A3B Collapsed fork Up-Down MCF7.xlsx")
A3H <- read_excel("A3H Collapsed fork Up-Down MCF7.xlsx")

# zero genes common
Collapsed_MCF10A <- Reduce(function(dtf1, dtf2) merge(dtf1, dtf2, by = "Identity"), list(A3A,A3B,A3H))


#NORMAL
setwd("/Users/shahina/Desktop/FW_ Protein Lists for IPA - different cell line/Normal fork Up-Down MCF7/raw_data/")

A3A <- read_excel("A3A Normal Fork Up-Down MCF7.xlsx")
A3B <- read_excel("A3B Normal Fork Up-Down MCF7.xlsx")
A3H <- read_excel("A3H Normal Fork Up-Down MCF7.xlsx")

#ZERO GENES COMMON
NORMAL_MCF10A <- Reduce(function(dtf1, dtf2) merge(dtf1, dtf2, by = "Identity"), list(A3A,A3B,A3H))

#STALLED
setwd("/Users/shahina/Desktop/FW_ Protein Lists for IPA - different cell line/Stalled Fork Up-Down MCF7/raw_data/")

A3A <- read_excel("A3A Stalled Fork Up-Down MCF7.xlsx")
A3B <- read_excel("A3B Stalled Fork Up-Down MCF7.xlsx")
A3H <- read_excel("A3H Stalled Fork Up-Down MCF7.xlsx")

#ZERO GENES COMMON
STALLED_MCF10A <- Reduce(function(dtf1, dtf2) merge(dtf1, dtf2, by = "Identity"), list(A3A,A3B,A3H))






#COLLASPED
#setwd("/Users/shahina/Desktop/FW_ Protein Lists for IPA/raw_data/")

A3A <- read.csv("DownUpIvsU_Filtered A3A Collapsed MCF10A.csv", header=TRUE)
A3B <- read.csv("DownUpIvsU_Filtered A3B Collapsed MCF10A.csv", header=TRUE)
A3H <- read.csv("DownUpIvsU_Filtered A3H Collapsed MCF10A.csv", header=TRUE)

Collapsed_MCF10A <- Reduce(function(dtf1, dtf2) merge(dtf1, dtf2, by = "Protein"), list(A3A,A3B,A3H))

Collapsed_MCF10A <- Collapsed_MCF10A[c(1,4,7,10)]
colnames(Collapsed_MCF10A) <- c("Protein","LogFC_A3A","LogFC_A3B","LogFC_A3H")

write.csv(Collapsed_MCF10A,"common_genes_collapsed_MCF10A.csv", quote=FALSE)

#Stalled
setwd("~/Desktop/FW_ Protein Lists for IPA/DownIvsU_Filtered Stalled Fork MCF10A/")

A3H <- read.csv("DownUpIvsU_Filtered A3H Stalled MCF10A.csv", header=TRUE)
A3A <- read.csv("DownUpIvsU_Filtered A3A Stalled MCF10A.csv", header=TRUE)
A3B <- read.csv("DownUpIvsU_Filtered A3B Stalled MCF10A.csv", header=TRUE)

Stalled_MCF10A <- Reduce(function(dtf1, dtf2) merge(dtf1, dtf2, by = "Protein"), list(A3A,A3B,A3H))

Stalled_MCF10A <- Stalled_MCF10A[c(1,4,7,10)]
colnames(Stalled_MCF10A) <- c("Protein","LogFC_A3A","LogFC_A3B","LogFC_A3H")

write.csv(Stalled_MCF10A,"common_genes_Stalled_MCF10A.csv", quote=FALSE)
