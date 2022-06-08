DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1LICH-001/star_alignment
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1LICH-001

for i in ${DATA}/*/*.bam
do
        path="${i%/Aligned*}";
	      sample_name="${path##*/}"
      
  sbatch $OUTDIR/04_RNASEQC.sh "${sample_name}" "${DATA}/${sample_name}/Aligned.sortedByCoord.out.bam"
 sleep 0.5
done 


#cd /globalhome/hxo752/HPC/tools/
#./multiqc -d ${OUTDIR}/human/rnaseqc/*metrics.tsv -o ${OUTDIR}/human/rnaseqc
#./multiqc -d ${OUTDIR}/human/rnaseqc/*exon_cv.tsv -o ${OUTDIR}/human/rnaseqc
