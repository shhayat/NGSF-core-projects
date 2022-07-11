OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/raw_data
for i in $(seq -w 86 89);
do
  sbatch fastq-dump.sh ${OUTDIR}/SRR197542${i} ${OUTDIR}/SRR197542${i}_pass.fastq.gz
  sleep 0.2
done
