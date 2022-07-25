DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/peakcall

sample_name=""
for sample in $DIR/*
do  
    sample_name+="${sample} "
 done
 
sbatch 07_IDR.sh "${sample_name}";
