for i in {78..91}
do
  NUM="${i:1}"
  OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/urothelial_carcinoma/fastq
  mkdir -p $OUTDIR
  echo "wget https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR993/00${NUM}/SRR99367${i}/SRR99367${i}_1.fastq.gz" >> $OUTDIR/path_to_fastq_files.sh
  echo "wget https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR993/00${NUM}/SRR99367${i}/SRR99367${i}_2.fastq.gz" >> $OUTDIR/path_to_fastq_files.sh
done
