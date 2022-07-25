DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/peakcall

peak_files=""
#for peak_file in $DIR/SRR*/*_peaks.sorted.narrowPeak
for peak_file in $DIR/SRR*/*_peaks.sorted.narrowPeak_selected_columns.bed
do  
    peak_files+="${peak_file}"
    #peak_files=$(echo "$peak_files" | sed 's/.narrowPeak\//.narrowPeak \//g')
    peak_files=$(echo "$peak_files" | sed 's/.bed\//.bed \//g')
 done
 
sbatch 07_IDR.sh "${peak_files}";
