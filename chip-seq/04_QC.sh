
module load r/4.1.2
OUTDIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/"
mkdir -p ${OUTDIR}/QC 
BAM_file=$1;

cd /globalhome/hxo752/HPC/tools/phantompeakqualtools

Rscript run_spp.R -c ${BAM_file} -savp xcor_phantompeakqualtools.pdf -odir ${OUTDIR}/QC -out=$xcor_metrics_phantompeakqualtools.txt
