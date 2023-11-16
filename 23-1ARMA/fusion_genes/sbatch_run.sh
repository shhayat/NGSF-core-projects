SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes
#submit fastqc job
#DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/fastq
#for i in $DATA/*_1.fastq.gz
#do
#      path="${i%_1*}";
#      sample_name=${path##*/};
#      fq1=${DATA}/${sample_name}_1.fastq.gz;
#      fq2=${DATA}/${sample_name}_2.fastq.gz;
#      sbatch ${SCRIPT_DIR}/01_FastQC.sh "${fq1}" "${fq2}"
 #done

#DATA=/datastore/NGSF001/datasets/canine_datasets/hystiocystic_sarcoma
#DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/fastq
#DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/lymphoma/fastq
#DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/urothelial_carcinoma/fastq
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/fastq
#for i in $DATA/*_1.fastq.gz
for i in $DATA/SRR5278034_1.fastq.gz $DATA/SRR5278034_1.fastq.gz
do
      path="${i%_1*}";
      sample_name=${path##*/};
      fq1=${DATA}/${sample_name}_1.fastq.gz;
      fq2=${DATA}/${sample_name}_2.fastq.gz;
      sbatch ${SCRIPT_DIR}/02_star_fusion_singularity.sh "${sample_name}" "${fq1}" "${fq2}"
done

#DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/starFusion
#DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/
#DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/lymphoma/analysis/
#DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/lymphoma/analysis/
#DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/urothelial_carcinoma/analysis/
#for i in $DATA/*/FusionInspector-validate/finspector.FusionInspector.fusions.abridged.tsv
#do
#      path="${i%/FusionInspector*}";
#      sample_name=${path##*/};
#      sbatch ${SCRIPT_DIR}/03_NTRK_gene_fusions.sh "${sample_name}"
#done

#DATA=/datastore/NGSF001/datasets/canine_datasets/icdc_data/bam
#for i in $DATA/*.bam
#do
#      path="${i%_sorted*}";
#      sample_name=${path##*/};
#      sbatch ${SCRIPT_DIR}/bam2fastq.sh "${sample_name}"
#done
