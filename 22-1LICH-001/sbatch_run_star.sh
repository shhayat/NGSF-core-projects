DATA=/datastore/NGSF001/projects/22-1LICH-001/fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1LICH-001

for i in $DATA/R2*.fastq.gz
do
        path="${i%_R*}";
        sample_name=${path##*/};
        fq1=${DATA}/${sample_name}_R1.fastq.gz;
	fq2=${DATA}/${sample_name}_R2.fastq.gz;
  
      sbatch $OUTDIR/02_star_mapping.sh "${sample_name}" "${fq1}" "${fq2}"
 sleep 0.5
done
