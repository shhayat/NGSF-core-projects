DATA=/datastore/NGSF001/experiments/depletion_tests/human/fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/depletion_tests/

for i in $(seq -w 13 24);
do

  for i in $DATA/*R1_001.fastq.gz
do
        R1="${i%_R1*}";
        R2=${R1##*/};
        fq1=${R1}_R1_001.fastq.gz
	    fq2=${R1}_R2_001.fastq.gz
  sbatch $OUTDIR/02_star_mapping.sh "sample_name" "${DATA}/${R1}.fq" "${DATA}/${R2}.fq"
 sleep 0.5
done 
