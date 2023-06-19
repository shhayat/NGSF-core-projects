SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes
#submit fastqc job
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/fastq
for i in $DATA/*_1.fastq.gz
do
      path="${i%_1*}";
      sample_name=${path##*/};
      fq1=${DATA}/${sample_name}_1.fastq.gz;
      fq2=${DATA}/${sample_name}_2.fastq.gz;
      sbatch ${SCRIPT_DIR}/01_FastQC.sh "${fq1}" "${fq2}"
 done

#submit star alignment job
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/fastq

for i in $DATA/*_1.fastq.gz
do
      path="${i%_1*}";
      sample_name=${path##*/};
      fq1=${DATA}/${sample_name}_1.fastq.gz;
      fq2=${DATA}/${sample_name}_2.fastq.gz;
      sbatch ${SCRIPT_DIR}/02_star_mapping.sh "${sample_name}" "${fq1}" "${fq2}"
done


#star_dir=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/star_alignment
#for i in ${star_dir}/D*/Chimeric.out.junction
#do
#      sbatch ${SCRIPT_DIR}/04_StarFusion.sh "${i}" 
#done

DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/fastq

for i in $DATA/*_1.fastq.gz
do
      path="${i%_1*}";
      sample_name=${path##*/};
      fq1=${DATA}/${sample_name}_1.fastq.gz;
      fq2=${DATA}/${sample_name}_2.fastq.gz;
      sbatch ${SCRIPT_DIR}/04_StarFusion.sh "${fq1}" "${fq2}"
done

