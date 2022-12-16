DATA=/datastore/NGSF001/projects/22-1MILE-001/fastq_umi
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2


for i in $DATA/D2*_R1*.fastq.gz
do
        path="${i%_D2*_R1*}";
        sample_name=${path##*/};
        fq1=${DATA}/${sample_name1}_R1_umi.fastq.gz;
	fq2=${DATA}/${sample_name1}_R3_umi.fastq.gz;
  
      sbatch ${SCRIPT_DIR}/03_salmon_quantification.sh "${sample_name}" "${fq1}" "${fq2}"
 sleep 0.5
done
