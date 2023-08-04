#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=idr
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=%j.out

#https://github.com/hbctraining/Intro-to-ChIPseq/blob/master/lessons/07_handling-replicates-idr.md
#Combining replicates to only get the highly reproducible peaks using the IDR method

module purge
module load python/3.10
module load scipy-stack/2023a
source $HOME/venvs/idr/bin/activate

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis
peaks=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/peakcall_with_pval0.05
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/IDR

files=$1;

mkdir -p $OUTDIR

idr --samples ${files} \
      --output-file ${OUTDIR}/idr.bed \
      --plot \
      --rank p.value \
      --log-output-file ${OUTDIR}/idr.log \
      --verbose

#conda deactivate
#Column 5 contains the scaled IDR value, min(int(log2(-125IDR), 1000) For example, peaks with an IDR of 0 have a score of 1000, 
#peaks with an IDR of 0.05 have a score of int(-125log2(0.05)) = 540, and IDR of 1.0 has a score of 0.
#select IDR of 0.05
awk '{if($5 >= 540) print $0}' ${OUTDIR}/idr.bed > ${OUTDIR}/idr_filtered.bed

#prep file for motif discovery

cut -f 1,2,3 ${OUTDIR}/idr_filtered.bed > ${OUTDIR}/idr_filtered_3_columns.bed 

#for motif discovery step repeat-masked version of the genome is required where all repeat sequences have been replaced with Ns
#we will generate masked genome based on peak intervals in idr_filtered.bed 
cd /globalhome/hxo752/HPC/tools
chmod a+x bedtools.static.binary
./bedtools.static.binary getfasta -fi /datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa \
                                  -bed ${OUTDIR}/idr_filtered_3_columns.bed \
                                  -fo ${OUTDIR}/genome.masked.on.idr_intervals.fa

deactivate
