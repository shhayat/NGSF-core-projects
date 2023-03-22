DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001/analysis/Alignment_v109
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001

for i in ${DATA}/*/*.bam
do
        path="${i%/Aligned*}";
	sample_name="${path##*/}"
      
  sbatch ${SCRIPT_DIR}/03_RNASEQC.sh "${sample_name}" "${DATA}/${sample_name}/Aligned.sortedByCoord.out.bam"
 sleep 0.5
done 
