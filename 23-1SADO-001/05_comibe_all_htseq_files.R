library(Rsubread)
library(magrittr)
setwd("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SADO-001/analysis/")
result_dir="htseq_counts"
sample_names <- list.files(result_dir, "R23")


df <- read.table("R2300027_htseq_counts1.txt", sep="\t")

#count features using featureCounts function
htseq_count <- sapply(sample_names, function(x)
			   read.delim(sprintf('%s/%s',result_dir, x), header=FALSE),             
			   simplify = FALSE, 
			   USE.NAMES = TRUE)


#convet list to a dataframe
#COUNTS
htseq_count1 <- htseq_count %>% lapply(function(x) x$V1) %>% 
	do.call(cbind, .) %>% 
	magrittr::set_colnames(names(htseq_count))

#ANNOTATIONS					  
feature_annotation <- feature_count %>% lapply(function(x) x$annotation) %>% 
	do.call(cbind, .) %>% 
	magrittr::extract(,c(1,7)) %>%
	magrittr::set_colnames(c('GeneID', 'gene_name'))

feature_count <- cbind(feature_annotation,feature_count1)

save(feature_count, file = 'feature_count.RData', compress = 'xz')
