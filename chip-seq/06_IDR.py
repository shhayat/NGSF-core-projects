#https://github.com/hbctraining/Intro-to-ChIPseq/blob/master/lessons/07_handling-replicates-idr.md
#Combining replicates to only get the highly reproducible peaks using the IDR method

OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/analysis/IDR

mkdir -p $OUTDIR
cd /globalhome/hxo752/HPC/tools/idr-2.0.3

idr --samples Nanog_Rep1_sorted_peaks.narrowPeak Nanog_Rep2_sorted_peaks.narrowPeak \
    --input-file-type narrowPeak \
    --rank p.value \
    --output-file idr \
    --plot \
    --log-output-file ${OUTDIR}/idr.log



