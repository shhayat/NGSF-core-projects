#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=markdup_add_RG
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=4:00:00
#SBATCH --mem=40G
#SBATCH  --output=recalibrate.out

gatk --java-options "-Djava.io.tmpdir=/lscratch/$SLURM_JOBID -Xms20G -Xmx20G -XX:ParallelGCThreads=2" HaplotypeCaller \
  -R /fdb/igenomes/Homo_sapiens/UCSC/hg38/Sequence/WholeGenomeFasta/genome.fa \
  -I NA12891_markdup_bqsr.bam \
  -O NA12891.g.vcf.gz \
  -ERC GVCF
