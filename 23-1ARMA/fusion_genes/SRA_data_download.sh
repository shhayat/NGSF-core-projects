
#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=sra_download
#SBATCH --cpus-per-task=1
#SBATCH --mem=185G
#SBATCH --time=20:00:00
#SBATCH --output=%j.out

sratoolkit=/globalhome/hxo752/HPC/tools/sratoolkit.3.0.1-ubuntu64/bin
#Normal Skin Tissue (Paired reads)
OUTPUT=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes

mkdir -p $OUTPUT/fastq

for i in {4369..4422}
do
  echo "Generating sra file for:  SRR17624${i}";
  ${sratoolkit}/prefetch SRR176243${i} -O $OUTPUT --progress;
  
  echo "Generating fastq for: SRR${i}";
  ${sratoolkit}/fastq-dump --outdir $OUTPUT/fastq --gzip --clip ${OUTPUT}/SRR17624${i}/SRR17624${i}.sra;
done
