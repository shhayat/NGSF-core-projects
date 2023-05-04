SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1JOHO-001

#run fastqc
jid1=$(sbatch ${SCRIPT_DIR}/01_FastQC.sh)

#run genome build
jid2=$(sbatch ${SCRIPT_DIR}/02_genome_build.sh)
#run star alignment
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1JOHO-001/analysis/Fastq
for i in $DATA/R*_R1.fastq.gz
do
      path="${i%_R*}";
      sample_name=${path##*/};
      fq1=${DATA}/${sample_name}_R1.fastq.gz;
      fq2=${DATA}/${sample_name}_R2.fastq.gz;
      jid3=$(sbatch --dependency=afterok:$jid2 ${SCRIPT_DIR}/03_star_mapping.sh "${sample_name}" "${fq1}" "${fq2}")
 sleep 0.5
done

#submit rnaseqc job
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1JOHO-001/analysis/star_alignment
for i in ${DATA}/*/*.bam
do
        path="${i%/Aligned*}";
	sample_name="${path##*/}
        jid4=$(sbatch --dependency=afterok:$jid3 ${SCRIPT_DIR}/04_RNASeQC.sh "${sample_name}" "${DATA}/${sample_name}/Aligned.sortedByCoord.out.bam")
	sleep 0.5
done 

#run feature count
sbatch --dependency=afterok:$jid4 ${SCRIPT_DIR}/sbatch_run_feature_count.sh
