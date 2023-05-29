DATA=/datastore/NGSF001/projects/23-1MILE-002/fastq
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002

for i in ${DATA}/R23*_R1_001.fastq.gz 
do
      path="${i%_R1*}";
      sample_name=${path##*/};
      path1="${i%_S*_R1*}";
      sample_name1=${path1##*/};
      
      fq1=${DATA}/${sample_name}_R1_001.fastq.gz;
      fq2=${DATA}/${sample_name}_R2_001.fastq.gz;
      
      sbatch ${SCRIPT_DIR}/01_Add_UMIs.sh ${sample_name1} "${fq1}" "${fq2}"
 done
 
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002/analysis/fq_with_umi_header
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002

for i in ${DATA}/R23*_R1.fastq.gz 
do
      path="${i%_R1*}";
      sample_name=${path##*/};
      fq1=${DATA}/${sample_name}_R1.fastq.gz;
      fq2=${DATA}/${sample_name}_R1.fastq.gz;
      
      sbatch ${SCRIPT_DIR}/02_FastQC.sh "${fq1}" "${fq2}"
 done
 


#DATA=/datastore/NGSF001/projects/23-1MILE-002/fastq
DATA=/datastore/NGSF001/projects/23-1MILE-002/fastq
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


DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002/analysis/star_alignment
for i in ${DATA}/*/*.bam
do
        path="${i%/Aligned*}";
	     sample_name="${path##*/}"
        sbatch ${SCRIPT_DIR}/03_RNASeQC.sh "${sample_name}" "${DATA}/${sample_name}/Aligned.sortedByCoord.out.bam"
	sleep 0.5
done 


for i in {122..130}
do
   bam=Aligned.sortedByCoord.out.bam
   sbatch ${SCRIPT_DIR}/04_remove_rnrna_and_dedupUMI.sh "R2300${i}" ${bam}
done

DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002/analysis/deduplication


for i in ${DATA}/*/*.bam
do
     path="${i%/Aligned*}";
     sample_name="${path##*/}"
     sbatch ${SCRIPT_DIR}/04_HTSeq_count.sh "${sample_name}" "${DATA}/${sample_name}/Aligned.sortedByCoord.out.bam"
     sleep 0.5
done 

