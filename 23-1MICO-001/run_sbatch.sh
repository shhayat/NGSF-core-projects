########
#FASTQC
########
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/Fastq
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001

for i in ${DATA}/D23*_R1.fastq.gz 
do
      path="${i%_R1*}";
      sample_name=${path##*/};
      fq1=${DATA}/${sample_name}_R1.fastq.gz;
      fq2=${DATA}/${sample_name}_R2.fastq.gz;
      
      sbatch ${SCRIPT_DIR}/02_FastQC.sh "${fq1}" "${fq2}"
 done

########
#MAPPING
########
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/Fastq
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001

for i in ${DATA}/D23*_R1.fastq.gz 
do
      path="${i%_R1*}";
      sample_name=${path##*/};
      fq1=${DATA}/${sample_name}_R1.fastq.gz;
      fq2=${DATA}/${sample_name}_R2.fastq.gz;

      sbatch ${SCRIPT_DIR}/04_bowtie_alignment.sh "${sample_name}" "${fq1}" "${fq2}"
 done


####################################
#MARK DUPLICATE AND ADD READ GROUPS
####################################

SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis
DATA='/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/alignment'

for i in $(seq -w 13 24);
do
  sbatch ${SCRIPT_DIR}/01_markduplicates_and_add_Read_group.sh E21000${i} "${DATA}/E21000${i}.sorted.bam"
  sleep 0.2
done
