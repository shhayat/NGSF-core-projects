#fastq files for canine hystiocystic sarcoma
for i in {6..9}
do
  #NUM="${i:2}"
  OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/fq_hystiocystic_sarcoma
  mkdir $OUTDIR
  echo "wget https://ftp.sra.ebi.ac.uk/vol1/fastq/DRR345/DRR34598${i}/DRR34598${i}_1.fastq.gz" >> $OUTDIR/path_to_fastq_files_R1.txt
  echo "wget https://ftp.sra.ebi.ac.uk/vol1/fastq/DRR345/DRR34598${i}/DRR34598${i}_2.fastq.gz" >> $OUTDIR/path_to_fastq_files_R2.txt
done
