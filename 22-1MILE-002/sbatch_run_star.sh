DATA=/datastore/NGSF001/projects/22-1MILE-002/processed_umi


for i in 098 099 100 101 102 103
do
  fq1=${DIR}/R2200${i}/R2200${i}_R1_umi_trimmed.fastq.gz
  fq2=${DIR}/R2200${i}/R2200${i}_R2_umi_trimmed.fastq.gz
  
  sbatch 01_star_mapping.sh R2200${i} ${fq1} ${fq2}
  
done
