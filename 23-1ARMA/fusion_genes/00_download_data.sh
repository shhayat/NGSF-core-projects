#fastq files for canine hystiocystic sarcoma
#study: Whole exome and transcriptomeanalysis revealed the activation of ERK andAkt signaling pathway in canine histiocytic sarcoma
#for i in {6..9}
#do
  ##NUM="${i:2}"
 # OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/fastq
 # mkdir -p $OUTDIR
 # echo "wget https://ftp.sra.ebi.ac.uk/vol1/fastq/DRR345/DRR34598${i}/DRR34598${i}_1.fastq.gz" >> $OUTDIR/path_to_fastq_files_R1.txt
 # echo "wget https://ftp.sra.ebi.ac.uk/vol1/fastq/DRR345/DRR34598${i}/DRR34598${i}_2.fastq.gz" >> $OUTDIR/path_to_fastq_files_R2.txt
#done

#fastq files for Canine Hemangiosarcoma
#study: Genomically Complex Human Angiosarcoma and Canine Hemangiosarcoma Establish Convergent Angiogenic Transcriptional Programs Driven by Novel Gene Fusions
for i in {10..60}
do
  NUM="${i:1}"
  OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hemangiosarcoma/fastq
  mkdir -p $OUTDIR
  echo "wget https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR527/00${NUM}/SRR52780${i}/SRR52780${i}_1.fastq.gz" >> $OUTDIR/path_to_fastq_files_R1.txt
  echo "wget https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR527//00${NUM}/SRR52780${i}/DRR34598${i}_2.fastq.gz" >> $OUTDIR/path_to_fastq_files_R2.txt
done




#cortisol-secreting adrenocortical tumor
#study: Transcriptome sequencing reveals two subtypes of cortisol-secreting adrenocortical tumors in dogs and identifies CYP26B1 as a potential new therapeutic target

#for i in {857..952}
#do
#  NUM="${i:2}"
#  OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/fq_adrenocorticalt_umor
#  mkdir -p $OUTDIR
#  echo "wget https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR178/0${NUM}/SRR17882${i}/SRR17882${i}.fastq.gz" >> $OUTDIR/path_to_fastq_files_R1.txt
#done

