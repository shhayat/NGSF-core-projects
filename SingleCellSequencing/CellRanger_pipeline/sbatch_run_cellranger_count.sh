SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/CellRanger_pipeline

for i in $(seq -w 1 2);
do
      SAMPLE_NAME="R230000${i}"
      sbatch ${SCRIPT_DIR}/02_cellranger_count.sh "${SAMPLE_NAME}"
 sleep 0.5
done
