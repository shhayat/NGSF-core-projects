DATA=/datastore/NGSF001/projects/2021/21-1MILE-001/fastq
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1LICH-001

for i in $DATA/R2*.fastq.gz
do
        path="${i%_R*}";
        sample_name=${path##*/};
        fq1=${DATA}/${sample_name}_R1_001.fastq.gz;
	fq2=${DATA}/${sample_name}_R2_001.fastq.gz;
  
      sbatch ${SCRIPT_DIR}/02_salmon_quantification.sh "${sample_name}" "${fq1}" "${fq2}"
 sleep 0.5
done
