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
#10..60
#for i in {10..29}
#do
#  NUM="${i:1}"
#  OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hemangiosarcoma/fastq
#  mkdir -p $OUTDIR
#  echo "wget https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR527/00${NUM}/SRR52780${i}/SRR52780${i}_1.fastq.gz" >> $OUTDIR/path_to_fastq_files_R1.txt
#  echo "wget https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR527/00${NUM}/SRR52780${i}/SRR52780${i}_2.fastq.gz" >> $OUTDIR/path_to_fastq_files_R2.txt
#done


#fastq files for Canine lymphoma
#study: RNA-Seq analysis of gene expression in 25 cases of canine lymphoma undergoing CHOP chemotherapy

#for i in {15..39}
#do
 # NUM="${i:1}"
 # OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/lymphoma/fastq
 # mkdir -p $OUTDIR
 # echo "wget https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR902/00${NUM}/SRR90290${i}/SRR90290${i}.fastq.gz" >> $OUTDIR/path_to_fastq_files.sh
#done

#fastq files for Canine oral squamous cell carcinomas
#study:olecular homology between canine spontaneous oral squamous cell carcinomas and human head-and-neck squamous cell carcinomas reveals disease drivers and therapeutic vulnerabilities
for i in 58 56 54 52 50 48 46 44 42 40
do
  NUM="${i:1}"
  OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/squamous_cell_carcinomas/fastq
  mkdir -p $OUTDIR
  echo "wget https://ftp.sra.ebi.ac.uk/vol1/fastq/ERR350/00${NUM}/ERR35048${i}/ERR35048${i}_1.fastq.gz" >> $OUTDIR/path_to_fastq_files.sh
  echo "wget https://ftp.sra.ebi.ac.uk/vol1/fastq/ERR350/00${NUM}/ERR35048${i}/ERR35048${i}_2.fastq.gz" >> $OUTDIR/path_to_fastq_files.sh
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

