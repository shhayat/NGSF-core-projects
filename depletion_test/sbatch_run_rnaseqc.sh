DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/depletion_test/human/star_alignment
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/depletion_test

for i in ${DATA}/*/Aligned.sortedByCoord.out.bam
do
        path="${i%Aligned*}";
	sample_name=${path//_*};
      
  sbatch $OUTDIR/03_RNASEQC.sh "${sample_name}" "${basename}"
 sleep 0.5
done 


