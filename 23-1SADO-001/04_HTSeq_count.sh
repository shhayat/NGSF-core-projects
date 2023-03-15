DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SADO-001/analysis/star_alignment
GTF=/datastore/NGSF001/analysis/references/human/gencode-40/gencode.v40.annotation.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SADO-001/analysis/htseq_counts

mkdir -p ${OUTDIR}

sample_name=$1; shift
BAM=$2

/globalhome/hxo752/HPC/anaconda3/envs/htseq/bin/htseq-count -f ${BAM} \
                                                            -s yes \
                                                            -t exon \
                                                            -i gene_id \
                                                            --additional-attr gene_name \
                                                            ${GTF} > ${sample_name}_htseq_counts.txt
                                                            
                                                            
                                                            
