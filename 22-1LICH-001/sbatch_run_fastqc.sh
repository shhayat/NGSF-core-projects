DATA=/datastore/NGSF001/projects/22-1LICH-001/fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1LICH-001


for fq in $DATA/*_001.fastq.gz
do
   sbatch ${OUTDIR}/01_FastQC.sh "${fq}"
   sleep 0.5
done 

wait

#cp /globalhome/hxo752/HPC/tools/multiqc ${SLURM_TMPDIR}
#chmod u+x ${SLURM_TMPDIR}/multiqc

#${SLURM_TMPDIR}/multiqc ${OUTDIR}/fastqc/*_fastqc.zip -o ${OUTDIR}/fastqc

cd /globalhome/hxo752/HPC/tools/
./multiqc ${OUTDIR}/fastqc/*_fastqc.zip -o ${OUTDIR}/fastqc
