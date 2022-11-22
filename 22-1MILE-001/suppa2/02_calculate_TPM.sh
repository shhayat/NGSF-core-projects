stringtie=/datastore/NGSF001/software/tools/stringtie
OUTDIR=


${stringtie}/stringtie ${bam_file}
-G ${GTF} \
-o $OUTDIR/${sample}.gtf
