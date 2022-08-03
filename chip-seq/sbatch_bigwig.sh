DIR=/globalhome/hxo752/HPC/chipseq/analysis/alignment
for i in 492444 492445 507859 507860
do
  sbatch bigwig.sh ${DIR}/SRR${i}.aligned_dedup.bam SRR${i}
  sleep 0.2
done
