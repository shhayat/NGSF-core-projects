DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/peakcall

narrowPeak_files=""
for narrowPeak_files in $DIR/*/*.peaks.sorted.narrowPeak
do  
    narrowPeak_files+="${narrowPeak_files} "
 done
 
sbatch 07_IDR.sh "${narrowPeak_files}";
