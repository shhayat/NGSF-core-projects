


idr_bed_file=$1; shift
bam_files=$1;
labels=$1;

NCPU=4

mkdir -p ${OUTDIR}/QC_after_peakcall
multiBamSummary BED-file \
                --BED ${idr_bed_file} \
                --bamfiles ${bam_files} \
                --labels ${labels} \
                --outFileName ${OUTDIR}/QC_after_peakcall/.npz \
                 -p ${NCPU}
