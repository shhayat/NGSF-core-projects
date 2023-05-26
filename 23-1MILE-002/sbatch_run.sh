DATA=/datastore/NGSF001/projects/23-1MILE-002/fastq
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002

for i in ${DATA}/R23*_R1_001.fastq.gz 
do
      path="${i%_R1*}";
      sample_name=${path##*/};
      fq1=${DATA}/${sample_name}_R1_001.fastq.gz;
      fq2=${DATA}/${sample_name}_R2_001.fastq.gz;
      
      sbatch ${SCRIPT_DIR}/01_FastQC.sh "${fq1}" "${fq2}"
 done
 


#DATA=/datastore/NGSF001/projects/23-1MILE-002/fastq
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002/analysis/fastq_trimmed
for i in ${DATA}/R23*_R1_001.fastq.gz 
do
      path="${i%_R1*}";
      sample_name=${path##*/};
      
      path1="${i%_S*_R1*}";
      sample_name1=${path1##*/};
      fq1=${DATA}/${sample_name}_R1_001.fastq.gz;
      fq2=${DATA}/${sample_name}_R2_001.fastq.gz;
      
      sbatch ${SCRIPT_DIR}/02_star_mapping.sh "${sample_name1}" "${fq1}" "${fq2}"
done


DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1TOSH-001/analysis/star_alignment
for i in ${DATA}/*/*.bam
do
        path="${i%/Aligned*}";
	     sample_name="${path##*/}"
        sbatch ${SCRIPT_DIR}/03_RNASeQC.sh "${sample_name}" "${DATA}/${sample_name}/Aligned.sortedByCoord.out.bam"
	sleep 0.5
done 

