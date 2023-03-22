#DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/analysis/Fastq
DATA=/datastore/NGSF001/projects/23-1ANLE-001/Analysis/fastq
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/CellRanger_pipeline

for i in $DATA/R23*_R1*
do
        path="${i%_S*}";
        sample_name=${path##*/};
  
      sbatch ${SCRIPT_DIR}/02_cellranger_count.sh "${sample_name}"
 sleep 0.5
done
