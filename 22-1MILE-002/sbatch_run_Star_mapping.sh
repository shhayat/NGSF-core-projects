DATA=/datastore/NGSF001/projects/22-1MILE-002/fastq
#098 099 100 

for i in {121..130}
do
  fq1=${DATA}/R2300${i}_R1_001.fastq.gz
  fq2=${DATA}/R2300${i}_R2_001.fastq.gz
  
  sbatch 02_star_mapping.sh R2200${i} ${fq1} ${fq2}
  
done
