DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/peakcall

narrowPeak_file=""
for sample in $DIR/*/*.peaks.sorted.narrowPeak
do  
    narrowPeak_files+="${narrowPeak_file} "
 done
 
sbatch 07_IDR.sh "${narrowPeak_files}";
