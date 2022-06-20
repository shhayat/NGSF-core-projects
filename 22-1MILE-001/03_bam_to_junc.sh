#!/bin/bash

#SBATCH --job-name=bams_to_juncs
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

set -eux


OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/analysis/bam_to_junct

module load samtools
cp -r /globalhome/hxo752/HPC/tools/regtools/build ${SLURM_TMPDIR}
chmod u+x ${SLURM_TMPDIR}/regtools/build

sample_name=$1; shift
bam_file=$1

mkdir -p ${OUTDIR}/${sample_name}
echo Converting $bam_file to ${bam_file}.junc
regtools junctions extract -a 8 -m 50 -M 500000 ${bam_file} -o ${OUTDIR}/${sample_name}/${sample_name}.junc

echo ${OUTDIR}/${sample_name}/${sample_name}.junc >> ${OUTDIR}/juncfiles.txt
