SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1TOSH-001

#submit bcl2fastq job
for i in /datastore/NGSF001/NB551711/2305*
do
    folder_name=${i##*/};
    sbatch ${SCRIPT_DIR}/00_bcl2tfastq.sh ${folder_name}
done	

#submit concatenate job
sbatch ${SCRIPT_DIR}/01_concatenate_lanes_from_each_folder.sh

#submit fastqc job
#jid2=$(sbatch --dependency=afterok:$jid1 ${SCRIPT_DIR}/02_FastQC.sh)
DATA=/datastore/NGSF001/projects/23-1TOSH-001/Fastq
for i in $DATA/R23*_R1.fastq.gz 
do
      path="${i%_R1*}";
      sample_name=${path##*/};
      path1="${i%_R1*}";
      sample_name1=${path1##*/};
      fq1=${DATA}/${sample_name}_R1.fastq.gz;
      fq2=${DATA}/${sample_name}_R2.fastq.gz;
      jid2=$(sbatch ${SCRIPT_DIR}/02_FastQC.sh "${fq1}" "${fq2}")
done

#submit star alignment job
DATA=/datastore/NGSF001/projects/23-1TOSH-001/Fastq
for i in $DATA/R23*_R1.fastq.gz 
do
      path="${i%_R1*}";
      sample_name=${path##*/};
      path1="${i%_R1*}";
      sample_name1=${path1##*/};
      fq1=${DATA}/${sample_name1}_R1.fastq.gz;
      fq2=${DATA}/${sample_name1}_R2.fastq.gz;
      jid3=$(sbatch ${SCRIPT_DIR}/03_star_mapping.sh "${sample_name}" "${fq1}" "${fq2}")
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
