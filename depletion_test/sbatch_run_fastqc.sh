#!/bin/bash

DATA=/datastore/NGSF001/experiments/depletion_tests/human/fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/depletion_test


for fq in $DATA/*_001.fastq.gz
do
   sbatch ${OUTDIR}/01_FastQC.sh "${fq}"
   sleep 0.5
done 

wait

cp ~/.local/bin/multiqc ${SLURM_TMPDIR}
chmod u+x ${SLURM_TMPDIR}/multiqc

${SLURM_TMPDIR}/multiqc ${OUTDIR}/fastqc/*_fastqc.zip -o ${OUTDIR}/fastqc
