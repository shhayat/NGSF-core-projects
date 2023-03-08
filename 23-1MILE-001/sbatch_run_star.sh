DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-001/analysis/fastq_trimmed
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-001


for i in $DATA/R23*_L001_R1_001.fastq.gz
do
        path="${i%_S*}";
        sample_name=${path##*/};
   
        fq1=${DATA}/${sample_name}_R1_001.fastq.gz
        fq2=${DATA}/${sample_name}_R2_001.fastq.gz

sbatch ${SCRIPT_DIR}/04_star_mapping.sh "${sample_name}" "${fq1}" "${fq2}"
 sleep 0.5
done	      
