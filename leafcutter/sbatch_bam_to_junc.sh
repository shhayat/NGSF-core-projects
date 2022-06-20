DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects//star_alignment
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/

for i in ${DATA}/*/*.bam
do

	path="${i%*}";     
	sample_path="${path%.no-rRNA.primary-aln.dedup.bam}"; 
	sample_name="${sample_path##*/}";
      
  sbatch ${OUTDIR}/bam_to_junc.sh "${sample_name}" "${DATA}/${sample_name}.no-rRNA.primary-aln.dedup.bam"
 sleep 0.5
done 
