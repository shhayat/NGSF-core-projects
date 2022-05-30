DATA=/datastore/NGSF001/experiments/depletion_tests/human/fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/new_proj

for i in $(seq -w 13 24);
do
  sbatch $OUTDIR/01_FastQC.sh "${DATA}/E21000${i}.fq"
 sleep 0.5
done 

wait

cp ~/.local/bin/multiqc ${SLURM_TMPDIR}
chmod u+x ${SLURM_TMPDIR}/multiqc

${SLURM_TMPDIR}/multiqc "${OUTDIR}/*_fastqc.zip" -o  ${OUTDIR}/fastqc
