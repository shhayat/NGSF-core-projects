#SRR492444  SRR492445  SRR507859  SRR507860
for i in 492444 492445 507859 507860
do
  sbatch 02_bowtie2.sh SRR${i} SRR${i}.fastq
  sleep 0.2
done
