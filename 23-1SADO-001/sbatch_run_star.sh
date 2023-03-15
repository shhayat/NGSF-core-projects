DATA=/datastore/NGSF001/NB551711/230314_NB551711_0067_AH2VMJBGXM/Alignment_1/20230315_045627/Fastq
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SADO-001

for i in $DATA/R2*_R1*.fastq.gz
do
        path="${i%_R*}";
        sample_name=${path##*/};
        fq1=${DATA}/${sample_name}_R1.fastq.gz;
	      fq2=${DATA}/${sample_name}_R2.fastq.gz;
  
      sbatch ${SCRIPT_DIR}/02_star_mapping.sh "${sample_name}" "${fq1}" "${fq2}"
 sleep 0.5
done
