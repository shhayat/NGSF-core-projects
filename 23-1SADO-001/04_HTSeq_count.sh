DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SADO-001/analysis/star_alignment



for BAM in $DATA/*/Aligned.sortedByCoord.out.bam
/globalhome/hxo752/HPC/anaconda3/envs/htseq/bin/htseq-count -f ${BAM} \
                                                            -s yes \
                                                            -t exon \
                                                            -
