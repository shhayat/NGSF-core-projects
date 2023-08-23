#!/bin/bash

#SBATCH --job-name=htseq_count
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

source $HOME/venvs/htseq/bin/activate

GTF=/datastore/NGSF001/analysis/references/rat/Rnor_6.0/ncbi-genomes-2020-10-30/GCF_000001895.5_Rnor_6.0/GCF_000001895.5_Rnor_6.0_genomic.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-002/analysis/htseq_counts_nonunique_all_and_reverse

mkdir -p ${OUTDIR}
sample_name=$1; shift
BAM=$1;

htseq-count -f bam \
            -r pos \
            -s reverse \
            -t exon \
            -i gene_id \
            --nonunique all \
            --additional-attr gene_name \
            ${BAM} \
            ${GTF} > ${OUTDIR}/${sample_name}_htseq_counts.txt
