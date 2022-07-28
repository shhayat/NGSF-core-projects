DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/peakcall

peak_files=""
#for peak_file in $DIR/SRR*/*_peaks.sorted.narrowPeak
for peak_file in $DIR/SRR*/*_summits.bed
do  
    peak_files+="${peak_file}"
    peak_files=$(echo "$peak_files" | sed 's/_summits.bed\//_summits.bed \//g')
 done
 
sbatch 07_IDR_handling_replicates.sh "${peak_files}";
