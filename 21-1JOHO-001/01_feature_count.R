library(Rsubread)
library(magrittr)
setwd("/datastore/NGSF001/projects/2021/21-1JOHO-001/")
result_dir="alignment"
sample_names <- list.files(result_dir, "R2")


#count features using featureCounts function
feature_count <- sapply(sample_names, function(x)
			   featureCounts(files = sprintf('%s/%s/Aligned.sortedByCoord.out.bam',result_dir, x),
			   annot.ext="/datastore//NGSF001/analysis/references/rat/Rnor_6.0/ncbi-genomes-2020-10-30/GCF_000001895.5_Rnor_6.0/GCF_000001895.5_Rnor_6.0_genomic.gtf",
			   isGTFAnnotationFile = TRUE,
			   GTF.attrType.extra  = c('gene_id'),
			   nthreads = 8, 
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
	magrittr::set_colnames(c('GeneID', 'gene_id'))

feature_count <- cbind(feature_annotation,feature_count1)

save(feature_count, file = 'feature_count.RData', compress = 'xz')
