#!/bin/bash

#SBATCH --job-name=star-align
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SADO-001/analysis/star_alignment
GTF=/datastore/NGSF001/analysis/references/human/gencode-40/gencode.v40.annotation.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SADO-001/analysis/htseq_counts
#GLIBC_2.29
mkdir -p ${OUTDIR}

sample_name=$1; shift
BAM=$1

/globalhome/hxo752/HPC/anaconda3/envs/htseq/bin/htseq-count -f bam \
                                                            -s yes \
                                                            -t exon \
                                                            -i gene_id \
                                                            --additional-attr gene_name \
                                                            ${BAM} \
                                                            ${GTF} > ${OUTDIR}/${sample_name}_htseq_counts.txt
