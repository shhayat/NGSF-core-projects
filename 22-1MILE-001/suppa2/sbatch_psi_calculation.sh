DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/suppa2_analysis/tpm/tpm
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2


for i in $DATA/*_quant/quant.sf
do
	      path="${i%_D*}";
        sample_name=${path##*/};
	      sample_name1=${sample_name%%_*};
        fq1=${DATA}/${sample_name1}_R1_umi.fastq.gz;
	      fq2=${DATA}/${sample_name1}_R3_umi.fastq.gz;
  
      sbatch ${SCRIPT_DIR}/04_salmon_quantification.sh "${sample_name1}" "${fq1}" "${fq2}"
 sleep 0.5
done
