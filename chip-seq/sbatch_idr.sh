DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/peakcall

peak_files=""
for peak_file in $DIR/SRR*/*_peaks.sorted.narrowPeak
do  
    peak_files+="${peak_file}"
        peak_files=$(echo "$peak_files" | sed 's/.narrowPeak\//.narrowPeak \//g')

 done
 
sbatch 07_IDR.sh "${peak_files}";
