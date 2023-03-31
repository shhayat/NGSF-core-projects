DIR=/datastore/NGSF001/projects/23-1ANLE-001/Analysis/fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/CellRanger_pipeline/nextflow
#generate one csv file for all samples 
for i in $(seq -w 1 2);
do
      echo "R230000${i},${DIR}/R230000${i}_S${i}_L001_R1_001.fastq.gz,${DIR}/R230000${i}_S${i}_L001_R2_001.fastq.gz" >> ${DIR}/sample_info.csv
      echo "R230000${i},${DIR}/R230000${i}_S${i}_L002_R1_001.fastq.gz,${DIR}/R230000${i}_S${i}_L002_R2_001.fastq.gz" >> ${DIR}/sample_info.csv
      echo "R230000${i},${DIR}/R230000${i}_S${i}_L003_R1_001.fastq.gz,${DIR}/R230000${i}_S${i}_L003_R2_001.fastq.gz" >> ${DIR}/sample_info.csv
      echo "R230000${i},${DIR}/R230000${i}_S${i}_L004_R1_001.fastq.gz,${DIR}/R230000${i}_S${i}_L004_R2_001.fastq.gz" >> ${DIR}/sample_info.csv
done
#add header to csv file
sed -i 1i'sample,fastq_1,fastq_2' ${DIR}/sample_info.csv
