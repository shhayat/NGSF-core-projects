library(Rsubread)
library(magrittr)
setwd("/datastore/NGSF001/projects/22-1ELSI-001/analysis/")
result_dir="Alignment"
sample_names <- list.files(result_dir, "R2")


#count features using featureCounts function
feature_count <- sapply(sample_names, function(x)
			   featureCounts(files = sprintf('/%s/%s/Aligned.sortedByCoord.out.bam',result_dir, x),
			   annot.ext="/datastore/NGSF001/analysis/references/horse/EquCab3.0/ensembl/release-103/Equus_caballus.EquCab3.0.103.gtf",
			   isGTFAnnotationFile = TRUE,
			   GTF.attrType.extra  = c('gene_name'),
			   nthreads = 10, 
			   isPairedEnd = TRUE), 
			   simplify = FALSE, 
			   USE.NAMES = TRUE)


#convet list to a dataframe
#COUNTS
feature_count1 <- feature_count %>% lapply(function(x) x$counts) %>% 
	do.call(cbind, .) %>% 
	magrittr::set_colnames(names(feature_count))

#ANNOTATIONS					  
feature_annotation <- feature_count %>% lapply(function(x) x$annotation) %>% 
	do.call(cbind, .) %>% 
	magrittr::extract(,c(1,7)) %>%
	magrittr::set_colnames(c('GeneID', 'gene_name'))

feature_count <- cbind(feature_annotation,feature_count1)

save(feature_count, file = '/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1ELSI-001/analysis/feature_count.RData', compress = 'xz')
