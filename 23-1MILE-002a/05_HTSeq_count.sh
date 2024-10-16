#!/bin/bash

#SBATCH --job-name=htseq_count
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

source $HOME/venvs/htseq/bin/activate

GTF=/datastore/NGSF001/analysis/references/iGenomes/Mouse/Mus_musculus/Ensembl/GRCm38/Annotation/Genes/genes.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-002a/analysis/htseq_counts_nonunique_all_and_unstranded

mkdir -p ${OUTDIR}

sample_name=$1; shift
BAM=$1;

htseq-count -f bam \
            -r pos \
            -s no \
            -t exon \
            -i gene_id \
            --nonunique all \
            --additional-attr gene_name \
            ${BAM} \
            ${GTF} > ${OUTDIR}/${sample_name}_htseq_counts.txt
                                                            

#Add tabs
#awk -v OFS="\t" '$1=$1' ${OUTDIR}/${sample_name}_htseq_counts.txt > ${OUTDIR}/${sample_name}_htseq_counts.tmp && mv ${OUTDIR}/${sample_name}_htseq_counts.tmp ${OUTDIR}/${sample_name}_htseq_counts.txt

#remove last 5 lines
#head -n-5 ${OUTDIR}/${sample_name}_htseq_counts.txt > ${OUTDIR}/${sample_name}_htseq_counts.tmp && mv ${OUTDIR}/${sample_name}_htseq_counts.tmp ${OUTDIR}/${sample_name}_htseq_counts.txt
