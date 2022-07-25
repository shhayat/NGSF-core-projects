DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/peakcall

narrowPeak_files=""
for narrowPeaks in $DIR/*/*.peaks.sorted.narrowPeak
do  
    narrowPeak_files+="${narrowPeaks} "
 done
 
sbatch 07_IDR.sh "${narrowPeak_files}";
