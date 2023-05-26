DATA_DIR=/datastore/NGSF001/projects/23-1MILE-002/fastq
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002
for i in ${DATA_DIR}/R23*_R1_001.fastq.gz 
do
      path="${i%_R1*}";
      sample_name=${path##*/};
      
      path1="${i%_S*_R1*}";
      sample_name1=${path1##*/};
      fq1=${DATA_DIR}/${sample_name}_R1_001.fastq.gz;
      fq2=${DATA_DIR}/${sample_name}_R2_001.fastq.gz;
      
      sbatch ${SCRIPT_DIR}/02_star_mapping.sh "${sample_name1}" "${fq1}" "${fq2}"
done
