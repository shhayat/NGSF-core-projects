
gatk --java-options "-Djava.io.tmpdir=/lscratch/$SLURM_JOBID -Xms20G -Xmx20G -XX:ParallelGCThreads=2" HaplotypeCaller \
  -R /fdb/igenomes/Homo_sapiens/UCSC/hg38/Sequence/WholeGenomeFasta/genome.fa \
  -I NA12891_markdup_bqsr.bam \
  -O NA12891.g.vcf.gz \
  -ERC GVCF
