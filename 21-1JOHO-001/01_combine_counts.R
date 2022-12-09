library(magrittr)
library(dplyr)

setwd("/Users/shahina/Projects/21-1JOHO-001/expression/")

 df <- list.files(pattern="*.counts.htseq.txt") %>% 
                  lapply(read.table) %>% 
                  bind_cols %>%
                  select(c(1,2,4,6,8,10,12))

colnames(df) <- c("gene_name","control_R75","treated_R76","treated_R77","treated_R78","control_R79","control_R80")

write.table(df, file="/Users/shahina/Projects/21-1JOHO-001/expression/feature_counts.txt", quote=FALSE, sep="\t",row.names=FALSE)
