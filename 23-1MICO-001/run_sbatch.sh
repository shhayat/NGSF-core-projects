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

SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/alignment

for i in {43..44};
do
  sbatch ${SCRIPT_DIR}/05_removeDuplicates_and_AddReadGroup.sh D230000${i} "${DATA}/D230000${i}/D230000${i}.aligned.bam"
  sleep 0.2
done

##############
#RECALIBRATION
##############
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/alignment

for i in {43..44};
do
  sbatch ${SCRIPT_DIR}/05_removeDuplicates_and_AddReadGroup.sh D230000${i} "${DATA}/D230000${i}/D230000${i}_mdup_rg_sort.bam
  sleep 0.2
done
