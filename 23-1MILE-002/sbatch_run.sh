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
      
      sbatch ${SCRIPT_DIR}/01_Add_UMIs.sh "${sample_name1}" "${fq1}" "${fq2}"
 done
 
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002/analysis/fq_with_umi_header
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002

for i in ${DATA}/R23*_R1.fastq.gz 
do
      path="${i%_R1*}";
      sample_name=${path##*/};
      fq1=${DATA}/${sample_name}_R1.fastq.gz;
      fq2=${DATA}/${sample_name}_R2.fastq.gz;
      
      sbatch ${SCRIPT_DIR}/02_FastQC.sh "${fq1}" "${fq2}"
 done
 


DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002/analysis/fq_with_umi_header

for i in ${DATA}/R23*_R1.fastq.gz 
do
      path="${i%_R1*}";
      sample_name=${path##*/};

      fq1=${DATA}/${sample_name}_R1.fastq.gz;
      fq2=${DATA}/${sample_name}_R2.fastq.gz;
      
      sbatch ${SCRIPT_DIR}/03_star_mapping.sh "${sample_name}" "${fq1}" "${fq2}"
done




for i in {122..130}
do
   bam=Aligned.sortedByCoord.out.bam
   sbatch ${SCRIPT_DIR}/04_remove_rnrna_and_dedupUMI.sh "R2300${i}" ${bam}
done

DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002/analysis/deduplication


for i in ${DATA}/*/*.no-rRNA.primary-aln.dedup.bam
do
     path="${i%/*.no-rRNA.primary-aln.dedup.bam}";
     sample_name="${path##*/}"
     sbatch ${SCRIPT_DIR}/05_HTSeq_count.sh "${sample_name}" "${DATA}/${sample_name}/${sample_name}.no-rRNA.primary-aln.dedup.bam"
     sleep 0.5
done 

