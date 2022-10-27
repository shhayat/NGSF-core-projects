DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-BETO-001/analysis/star_alignment
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-BETO-001

for i in ${DATA}/*/*.bam
do
        path="${i%/Aligned*}";
	      sample_name="${path##*/}"
      
  sbatch ${SCRIPT_DIR}/04_RNASEQC.sh "${sample_name}" "${DATA}/${sample_name}/Aligned.sortedByCoord.out.bam"
 sleep 0.5
done 
