DATA=/datastore/NGSF001/experiments/depletion_tests/human/fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/depletion_tests

  for i in $DATA/*R1_001.fastq.gz
do
        R1="${i%_R1*}";
        R2=${R1###*/};
        fq1=${R2}_R1_001.fastq.gz
	fq2=${R2}_R2_001.fastq.gz
  sbatch $OUTDIR/03_RNASEQC.sh "${R2}" "${fq1}" "${DATA}/${R2}.fq"
 sleep 0.5
done 
