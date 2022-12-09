library(magrittr)
library(dplyr)

setwd("/Users/shahina/Projects/21-1JOHO-001/expression/")

 df <- list.files(pattern="*.counts.htseq.txt") %>% 
                  lapply(read.table) %>% 
                  bind_cols %>%
                  select(c(1,2,4,6,8,10,12))

colnames(df) <- c("gene_name","R2100175","R2100176","R2100177","R2100178","R2100179","R2100180")

rownames(df) <- df$gene_name
df <- df[2:7]

write.table(df, file="/Users/shahina/Projects/21-1JOHO-001/expression/feature_counts.txt", quote=FALSE, sep="\t",row.names=TRUE)
