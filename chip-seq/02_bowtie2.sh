#!/bin/bash

#SBATCH --job-name=bams_to_juncs
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

set -eux

cd /globalhome/hxo752/HPC/tools/bowtie2-2.4.5-linux-x86_64

./bowtie2

#https://www.hdsu.org/chipatac2020/

