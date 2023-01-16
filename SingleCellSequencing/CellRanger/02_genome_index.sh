

NCPUS=10
cellranger=/datastore/NGSF001/software/tools/cellranger-7.1.0/bin

${cellranger}/cellranger mkref \
  --nthreads={NCPUS} \
  --genome={OUTPUT FOLDER FOR INDEX} \
  --fasta={GENOME FASTA} \
  --genes={ANNOTATION GTF}
