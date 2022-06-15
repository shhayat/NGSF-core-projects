#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=01:30:00
#SBATCH --mem=40G

set -eux


OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects//analysis/bam_to_junct

module load samtools
cp /globalhome/hxo752/HPC/tools/regtools/build ${SLURM_TMPDIR}
chmod u+x ${SLURM_TMPDIR}/regtools/build

sample_name=$1; shift
bam_file=$1

mkdir -p ${OUTDIR}/${sample_name}
echo Converting $bamfile to $bamfile.junc
regtools junctions extract -a 8 -m 50 -M 500000 ${bam_file} -o ${OUTDIR}/${sample_name}/${sample_name}.junc
echo ${OUTDIR}/${sample_name}/${sample_name}.junc >> ${OUTDIR}/${sample_name}/juncfiles.txt
