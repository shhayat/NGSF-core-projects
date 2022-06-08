library(Rsubread)
library(magrittr)
setwd("/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1LICH-001/")
result_dir="star_alignment"
sample_names <- list.files(result_dir, "")


#count features using featureCounts function
feature_count <- sapply(sample_names, function(x)
			   featureCounts(files = sprintf('%s/%s/Aligned.sortedByCoord.out.bam',result_dir, x),
			   annot.ext="/datastore/NGSF001/analysis/references/human/gencode-40/gencode.v40.annotation_mod.gtf",
			   isGTFAnnotationFile = TRUE,
			   nthreads = 8, 
			   isPairedEnd = TRUE), 
			   simplify = FALSE, 
			   USE.NAMES = TRUE)
			   

#convet list to a dataframe
feature_count <- feature_count %>% lapply(function(x) x) %>% 
                do.call(cbind, .) %>% 
	        magrittr::set_colnames(names(feature_count))

#save dataframe A and B
save(feature_count, file = 'feature_count.RData', compress = 'xz')
