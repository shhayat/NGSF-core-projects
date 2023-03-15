DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SADO-001/analysis/star_alignment
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SADO-001

for i in ${DATA}/*/*.bam
do
     path="${i%/Aligned*}";
	   sample_name="${path##*/}"
     sbatch ${SCRIPT_DIR}/04_HTSeq_count.sh "${sample_name}" "${DATA}/${sample_name}/Aligned.sortedByCoord.out.bam"
     sleep 0.5
done 
