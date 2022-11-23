#DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-BETO-001/analysis/star_alignment
DATA=/datastore/NGSF001/projects/22-1MILE-001/deduplication/umi-tools
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2

for i in ${DATA}/*.bam
do

	path="${i%*}";     
	sample_path="${path%.no-rRNA.primary-aln.dedup.bam}"; 
	sample_name="${sample_path##*/}";
 
  sbatch ${SCRIPT_DIR}/02_calculate_TPM.sh "${sample_name}" "${DATA}/${sample_name}.no-rRNA.primary-aln.dedup.bam"
 sleep 0.5
done 
