for i in 63 64 65 66 72 73 74 75 80 81 82 83 84 89 90 91 92 93
do
  NUM="${i:1}"
  OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SCWI-001/Additional_Study/
  mkdir -p $OUTDIR/fastq
  echo "wget https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR716/00${NUM}/SRR71663${i}/SRR71663${i}.fastq.gz" >> $OUTDIR/path_to_fastq_files.sh
done
