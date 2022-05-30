DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/depletion_tests/human/star_alignment
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/depletion_test

for i in ${DATA}/*/Aligned.sortedByCoord.out.bam
do
        path="${i%*}";
        basename=${path##*/};
	sample_name=${basename//_*};
      
  sbatch $OUTDIR/03_RNASEQC.sh "${sample_name}" "${basename}"
 sleep 0.5
done 


