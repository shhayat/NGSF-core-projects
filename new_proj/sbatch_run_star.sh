DATA=/datastore/NGSF001/experiments/depletion_tests/human/fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/depletion_tests

  for i in $DATA/*R1_001.fastq.gz
do
        path="${i%_R1*}";
        basename=${path##*/};
	sample_name=${basename//_*};
        fq1=${basename}_R1_001.fastq.gz;
	fq2=${basename}_R2_001.fastq.gz;
  sbatch $OUTDIR/03_RNASEQC.sh "${sample_name}" "${fq1}" "${fq2}"
 sleep 0.5
done 
