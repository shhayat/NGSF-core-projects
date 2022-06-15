DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects//star_alignment
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects//

for i in ${DATA}/*/*.bam
do
        path="${i%/Aligned*}";
	sample_name="${path##*/}"
      
  sbatch ${OUTDIR}/bam_to_junc.sh "${sample_name}" "${DATA}/${sample_name}/Aligned.sortedByCoord.out.bam"
 sleep 0.5
done 
