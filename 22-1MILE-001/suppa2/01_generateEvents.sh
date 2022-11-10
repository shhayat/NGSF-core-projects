



GTF=
OUTDIR=

python3.4 suppa.py generateEvents \
                          -i $GTF \ 
                          -o $OUTDIR/events_from_gtf \
                          -f ioe \
                          -e SE SS MX RI FL
                
