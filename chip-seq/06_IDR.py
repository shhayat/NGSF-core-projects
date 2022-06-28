#https://github.com/hbctraining/Intro-to-ChIPseq/blob/master/lessons/07_handling-replicates-idr.md
#Combining replicates to only get the highly reproducible peaks using the IDR method

peaks=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/analysis/peakcall
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/analysis/IDR

sample_name=1;

mkdir -p $OUTDIR
cd /globalhome/hxo752/HPC/tools/idr-2.0.3

idr --samples  ${peaks}/${sample_name}/${sample_name}.peaks.sorted.narrowPeak  ${peaks}/${sample_name}/${sample_name}.peaks.sorted.narrowPeak \
    --input-file-type narrowPeak \
    --rank p.value \
    --output-file idr \
    --plot \
    --log-output-file ${OUTDIR}/idr.log



