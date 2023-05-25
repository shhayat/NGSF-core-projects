#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=mapping
#SBATCH --ntasks=1
#BATCH --cpus-per-task=8
#SBATCH --time=03:00:00
#SBATCH --mem=60G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

set -eux

module load samtools

NCPUS=4
#work adapted from https://github.com/ngsf-usask/scripts/tree/main/RNAseq/22-1MILE-002
DIR=/23-1MILE-002/
star=/datastore/NGSF001/software/tools/STAR-2.7.4a/bin/Linux_x86_64
INDEX=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-002/star-index

sample_name=$1; shift
fq1=$1; shift
fq2=$1;

mkdir -p ${DIR}/alignment/${sample_name}

#star-twopass
${star}/STAR --runMode alignReads \
    --runThreadN ${NCPUS} \
    --genomeDir ${INDEX} \
    --readFilesCommand zcat \
    --readFilesIn ${fq1} ${fq2} \
    --twopassMode Basic \
    --outSAMstrandField intronMotif \
    --outSAMtype BAM SortedByCoordinate \
    --outFileNamePrefix ${DIR}/alignment/${sample_name}/star_ \
    && samtools index ${DIR}/alignment/${sample_name}/star_Aligned.sortedByCoord.out.bam
