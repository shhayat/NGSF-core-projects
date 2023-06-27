SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes
#submit fastqc job
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/fastq
for i in $DATA/*_1.fastq.gz
do
      path="${i%_1*}";
      sample_name=${path##*/};
      fq1=${DATA}/${sample_name}_1.fastq.gz;
      fq2=${DATA}/${sample_name}_2.fastq.gz;
      sbatch ${SCRIPT_DIR}/01_FastQC.sh "${fq1}" "${fq2}"
 done

#DATA=/datastore/NGSF001/datasets/canine_datasets/hystiocystic_sarcoma
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hemangiosarcoma/fastq
for i in $DATA/*_1.fastq.gz
do
      path="${i%_1*}";
      sample_name=${path##*/};
      fq1=${DATA}/${sample_name}_1.fastq.gz;
      fq2=${DATA}/${sample_name}_2.fastq.gz;
      sbatch ${SCRIPT_DIR}/02_star_fusion_singularity.sh "${sample_name}" "${fq1}" "${fq2}"
done

#DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/starFusion
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hemangiosarcoma/analysis/
for i in $DATA/*/finspector.FusionInspector.fusions.abridged.tsv
do
      path="${i%/fin*}";
      sample_name=${path##*/};
      sbatch ${SCRIPT_DIR}/03_NTRK_gene_fusions.sh "${sample_name}"
done

