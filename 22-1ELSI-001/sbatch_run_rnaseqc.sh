DATA=/datastore/NGSF001/projects/22-1ELSI-001/analysis/Alignment
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1ELSI-001

for i in ${DATA}/*/*.bam
do
        path="${i%/Aligned*}";
	      sample_name="${path##*/}"
      
  sbatch ${SCRIPT_DIR}/03_RNASEQC.sh "${sample_name}" "${DATA}/${sample_name}/Aligned.sortedByCoord.out.bam"
 sleep 0.5
done 
