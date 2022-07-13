for i in $(seq -w 86);
do
  sbatch 02_bowtie2.sh SRR197542${i} SRR197542${i}_pass.fastq
  sleep 0.2
done
