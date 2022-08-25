DATA=/datastore/NGSF001/projects/22-1MILE-002/fastq_umi
#098

for i in 099 100 101 102 103
do
  fq1=${DATA}/R2200${i}_R1_umi.fastq.gz
  fq2=${DATA}/R2200${i}_R3_umi.fastq.gz
  
  sbatch 01_star_mapping.sh R2200${i} ${fq1} ${fq2}
  
done
