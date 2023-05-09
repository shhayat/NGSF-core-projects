SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1TOSH-001

#submit concatenate job
#jid1=$(sbatch ${SCRIPT_DIR}/01_concatenate_lanes_from_each_folder.sh)

#submit fastqc job
#jid2=$(sbatch --dependency=afterok:$jid1 ${SCRIPT_DIR}/02_FastQC.sh)
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1TOSH-001/fastq
for i in $DATA/R23*_R1_001.fastq.gz;
do
      path="${i%_R1*}";
      sample_name=${path##*/};
      fq1=${DATA}/${sample_name}_R1_001.fastq.gz;
      fq2=${DATA}/${sample_name}_R2_001.fastq.gz;
      jid2=$(sbatch ${SCRIPT_DIR}/02_FastQC.sh "${fq1}" "${fq2}")
done

#submit star alignment job
DATA=/datastore/NGSF001/projects/23-1TOSH-001/fastq
for i in $DATA/R23*_R1_001.fastq.gz;
#for i in $(seq -w 66 121)
do
      path="${i%_S*}";
      sample_name=${path##*/};
      path1="${i%_R*}";
      sample_name1=${path1##*/};
      fq1=${DATA}/${sample_name1}_R1_001.fastq.gz;
      fq2=${DATA}/${sample_name1}_R2_001.fastq.gz;
      jid3=$(sbatch ${SCRIPT_DIR}/03_star_mapping.sh "${sample_name}" "${fq1}" "${fq2}")
 sleep 0.5
done

#submit rnaseqc job
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1TOSH-001/analysis/star_alignment
for i in ${DATA}/*/*.bam
do
        path="${i%/Aligned*}";
	sample_name="${path##*/}"
        jid4=$(sbatch --dependency=afterok:$jid3 ${SCRIPT_DIR}/04_RNASeQC.sh "${sample_name}" "${DATA}/${sample_name}/Aligned.sortedByCoord.out.bam")
	sleep 0.5
done 

#run feature count
#sbatch --dependency=afterok:$jid4 ${SCRIPT_DIR}/sbatch_run_feature_count.sh
