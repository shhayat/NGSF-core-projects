


SUPPA=/globalhome/hxo752/HPC/anaconda3/envs/suppa/bin
GTF=
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2_analysis

${SUPPA}/python ${SUPPA}/suppa.py generateEvents \
                              -i $GTF \ 
                              -o $OUTDIR/events_from_gtf \
                              -f ioe \
                              -e SE SS MX RI FL
                
