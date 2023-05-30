library(magrittr)
setwd("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002/analysis/")
result_dir="htseq_counts"
sample_names <- list.files(result_dir, "R23")

sample_names <- gsub("_htseq_counts.txt", "", sample_names)


#count features using featureCounts function
htseq_count <- sapply(sample_names, function(x)
			   read.delim(sprintf('%s/%s_htseq_counts.txt',result_dir, x), header=FALSE),             
			   simplify = FALSE, 
			   USE.NAMES = TRUE)


#convet list to a dataframe
#COUNTS
htseq_count1 <- htseq_count %>% lapply(function(x) x$V3) %>% 
	do.call(cbind, .) %>% 
	magrittr::set_colnames(names(htseq_count))

#ANNOTATIONS					  
htseq_annotation <- htseq_count %>% lapply(function(x) x) %>% 
	do.call(cbind, .) %>% 
	magrittr::extract(,c(1,2)) %>%
	magrittr::set_colnames(c('GeneID', 'gene_name'))

feature_count <- cbind(htseq_annotation,htseq_count1)

write.table(feature_count, '/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002/analysis/htseq_counts/htseq_count.txt', sep="\t", row.names=FALSE, quote=FALSE)
#save(feature_count, file = 'feature_count.RData', compress = 'xz')
