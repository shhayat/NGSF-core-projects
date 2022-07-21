
module load r/4.1.2
OUTDIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis"

mkdir -p ${OUTDIR}/QC 
sample=$1;

cd /globalhome/hxo752/HPC/tools/phantompeakqualtools

Rscript run_spp.R -c ${OUTDIR}/alignment/${sample_name}/${sample_name}.aligned_dedup.bam -savp xcor_phantompeakqualtools.pdf -odir ${OUTDIR}/QC -out=xcor_metrics_phantompeakqualtools.txt
