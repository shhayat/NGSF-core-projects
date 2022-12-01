#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=tpm
#SBATCH --ntasks=1
#BATCH --cpus-per-task=8
#SBATCH --time=03:00:00
#SBATCH --mem=80G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out


stringtie=/datastore/NGSF001/software/tools/stringtie
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/suppa2_analysis/tpm
#GTF=/datastore/NGSF001/analysis/references/iGenomes/Rat/Rattus_norvegicus/Ensembl/Rnor_6.0/Annotation/Genes/genes.gtf
GTF=/datastore/NGSF001/analysis/references/rat/Rnor_6.0/ncbi-genomes-2020-10-30/GCF_000001895.5_Rnor_6.0/GCF_000001895.5_Rnor_6.0_genomic.gtf
mkdir -p ${OUTDIR}

sample_name=$1; shift
bam_file=$1;

echo ${bam_file};
echo ${sample_name};
${stringtie}/stringtie ${bam_file} -G ${GTF} -A ${OUTDIR}/${sample_name}.txt

