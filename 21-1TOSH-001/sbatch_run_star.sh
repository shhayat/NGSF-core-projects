DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001/new_analysis/Trimming
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001


for i in $DATA/R20*R1*.fastq.gz
do
        path="${i%_R*}";
        sample_name=${path##*/};
        fq1=${DATA}/${sample_name}_R1_trimmed.fastq.gz;  
	      fq2=${DATA}/${sample_name}_R2_trimmed.fastq.gz;  
  
      sbatch ${SCRIPT_DIR}/01_star_mapping.sh "${sample_name}" "${fq1}" "${fq2}"
 sleep 0.5
done
