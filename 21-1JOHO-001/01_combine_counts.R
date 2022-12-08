library(magrittr)

setwd("/datastore/NGSF001/projects/2021/21-1JOHO-001/expression")

Files <- lapply(Sys.glob("*.counts.htseq.txt"), read.table)

 df <- list.files(pattern="*.counts.htseq.txt") %>% 
                  lapply(read.table) %>% 
                  bind_cols 
