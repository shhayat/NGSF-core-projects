#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=01:00:00
#SBATCH --mem=5G

module load python/3.9

sample_name=$1; shift
bam_file=$1
#GTF file needs to be modified for running RNASeQC
GTF=/datastore/NGSF001/analysis/references/human/gencode-40/gencode.v40.annotation_mod.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANLE-004/analysis/rnaseqc
mkdir -p ${OUTDIR}

#cp /globalhome/hxo752/HPC/tools/rnaseqc/python/rnaseqc/run.py ${SLURM_TMPDIR}
#chmod u+x ${SLURM_TMPDIR}/run.py

#cd ${SLURM_TMPDIR}/rnaseqc
cd /globalhome/hxo752/HPC/sources/rnaseqc
./rnaseqc.v2.4.2.linux \
         ${GTF} \
         ${bam_file} \
         --sample=${sample_name} \
         ${OUTDIR}
