DATA=
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/new_proj

for i in $(seq -w 13 24);
do
  sbatch $OUTDIR/01_FastQC.sh "${DATA}/E21000${i}.fq"
 sleep 0.5
done 

wait

~/.local/bin/multiqc $OUTDIR/*_fastqc.zip" -o  $OUTDIR/fastqc
