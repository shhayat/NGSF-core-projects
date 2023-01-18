DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/analysis/Fastq
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/

#for i in $DATA/Brain_Tumor_3p_S2_L00*.fastq.gz
#do
#        path="${i%_L*}";
#        sample_name=${path##*/};
  
#      sbatch ${SCRIPT_DIR}/02_cellranger_count.sh "${sample_name}"
# sleep 0.5
#done
