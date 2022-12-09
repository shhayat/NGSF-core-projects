library(magrittr)

setwd("/Users/shahina/Projects/21-1JOHO-001/")

Files <- lapply(Sys.glob("*.counts.htseq.txt"), read.table)

 df <- list.files(pattern="*.counts.htseq.txt") %>% 
                  lapply(read.table) %>% 
                  bind_cols 
