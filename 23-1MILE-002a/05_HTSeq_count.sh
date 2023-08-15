#!/bin/bash

#SBATCH --job-name=htseq_count
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

source $HOME/.bashrc
conda activate glibc

GTF=/datastore/NGSF001/analysis/references/iGenomes/Mouse/Mus_musculus/Ensembl/GRCm38/Annotation/Genes/genes.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002a/analysis/htseq_counts

mkdir -p ${OUTDIR}

sample_name=$1; shift
BAM=$1


#cd .local/lib/python3.7/site-packages/
cd /globalhome/hxo752/HPC/anaconda3/envs/htseq/bin
htseq-count -f bam \
            -r pos \
            -s yes \
            -t exon \
            -i gene_id \
            --nonunique all
            --additional-attr gene_name \
            ${BAM} \
            ${GTF} > ${OUTDIR}/${sample_name}_htseq_counts.txt
                                                            
conda deactivate

#remove .[0-9] from each line from ffrist columm
#awk '{ gsub(".[0-9]*$", "", $1); print }' ${OUTDIR}/${sample_name}_htseq_counts.txt > ${OUTDIR}/${sample_name}_htseq_counts.tmp && mv ${OUTDIR}/${sample_name}_htseq_counts.tmp ${OUTDIR}/${sample_name}_htseq_counts.txt
#Add tabs
awk -v OFS="\t" '$1=$1' ${OUTDIR}/${sample_name}_htseq_counts.txt > ${OUTDIR}/${sample_name}_htseq_counts.tmp && mv ${OUTDIR}/${sample_name}_htseq_counts.tmp ${OUTDIR}/${sample_name}_htseq_counts.txt

#remove last 5 lines
head -n-5 ${OUTDIR}/${sample_name}_htseq_counts.txt > ${OUTDIR}/${sample_name}_htseq_counts.tmp && mv ${OUTDIR}/${sample_name}_htseq_counts.tmp ${OUTDIR}/${sample_name}_htseq_counts.txt
