DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/analysis/count_files/
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/CellRanger_pipeline

#generate one csv file for all samples 
for i in $(seq -w 1 2);
do
      echo "$R230000${i},${DIR}/out/molecule_info.h5" >> ${DIR}/sample_info.csv
done
printf '%b' 'sample_id,molecule_h5g\n' | cat - ${DIR}/sample_info.csv 


sbatch ${SCRIPT_DIR}/02_cellranger_count.sh "${SAMPLE_NAME}"
