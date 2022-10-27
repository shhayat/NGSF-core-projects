DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-BETO-001/Fastq
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-BETO-001/

for i in $DATA/R22*_R1.fastq.gz
do
        path="${i%_R*}";
        sample_name=${path##*/};
        fq1=${DATA}/${sample_name}_R1.fastq.gz;
	      fq2=${DATA}/${sample_name}_R2.fastq.gz;
  
      sbatch ${SCRIPT_DIR}/02_star_mapping.sh "${sample_name}" "${fq1}" "${fq2}"
 sleep 0.5
done
