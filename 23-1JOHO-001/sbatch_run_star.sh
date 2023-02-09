DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1JOHO-001/analysis/Fastq
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1JOHO-001


#for i in $DATA/R*.fastq.gz
for i in $DATA/R*48*.fastq.gz $DATA/R*50*.fastq.gz $DATA/R*51*.fastq.gz $DATA/R*61*.fastq.gz
do
        path="${i%_R*}";
        sample_name=${path##*/};
        fq1=${DATA}/${sample_name}_R1.fastq.gz;
	      fq2=${DATA}/${sample_name}_R2.fastq.gz;
  
      sbatch ${SCRIPT_DIR}/03_star_mapping.sh "${sample_name}" "${fq1}" "${fq2}"
 sleep 0.5
done
