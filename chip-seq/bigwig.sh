#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=bigwig-deeptools
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module load python/3.7.7
#deeptools
cd /globalhome/hxo752/HPC/.local/lib/python3.7/site-packages/deeptools/

NCPUS=4
DIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis"

mkdir -r ${DIR}/bigWig

chip=$1; shift
input=$1; shift
sample_name=$1;

#generate bigwig files to view in IGV
#normalize the ChIP against the input
bamCompare -b1 ${chip} \
           -b2 ${input} \
            -o ${DIR}/bigWig/${sample_name}.bw \
            --binSize 20 \
            --normalizeUsing BPM \
            --smoothLength 60 \
            --extendReads 150 \
            --centerReads \
            -p ${NCPUS} 2> ${DIR}/bigWig/${sample_name}_bamCompare.log
         

