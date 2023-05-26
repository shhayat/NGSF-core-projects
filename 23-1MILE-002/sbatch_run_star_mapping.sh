DATA=
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002
for i in $DATA/R23*_R1_001.fastq.gz 
do
      path="${i%_R1*}";
      sample_name=${path##*/};
      
      path1="${i%_S*_R1*}";
      sample_name1=${path1##*/};
      fq1=${DATA}/${sample_name}_R1_001.fastq.gz;
      fq2=${DATA}/${sample_name}_R2_001.fastq.gz;
      
      sbatch ${DATA}/02_star_mapping.sh "${sample_name1}" "${fq1}" "${fq2}"
done
