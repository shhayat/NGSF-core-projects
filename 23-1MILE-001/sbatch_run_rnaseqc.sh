
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-001/analysis/fastq_trimmed
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-001



for i in ${DATA}/R23*_L001_R1_001.fastq.gz
do
        path="${i%_L001*}";
        sample_name=${path##*/};
	bam=${sample_name}.no-rRNA.primary-aln.dedup.bam
      
  sbatch ${SCRIPT_DIR}/07_RNASeQC.sh "${sample_name}" "${bam}"
 sleep 0.5
done 
