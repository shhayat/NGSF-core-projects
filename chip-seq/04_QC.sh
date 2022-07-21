
module load r/4.1.2
OUTDIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis"

mkdir -p ${OUTDIR}/QC/phantompeakqualtools
sample=$1;

cd /globalhome/hxo752/HPC/tools/phantompeakqualtools

Rscript run_spp.R -c ${OUTDIR}/alignment/${sample_name}/${sample_name}.aligned_dedup.bam -savp xcor_${sample}.pdf -odir ${OUTDIR}/QC/phantompeakqualtools -out=xcor_metrics_${sample}.txt
