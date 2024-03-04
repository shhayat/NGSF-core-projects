for i in {63..91}
do
  NUM="${i:1}"
  OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SCWI-001/analysis/Additional_Study/fastq
  mkdir -p $OUTDIR
  echo "wget https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR716/00${NUM}/SRR71663${i}/SRR71663${i}_1.fastq.gz" >> $OUTDIR/path_to_fastq_files.sh
done
