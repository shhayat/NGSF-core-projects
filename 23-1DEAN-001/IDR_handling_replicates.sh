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
peaks_dir=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/peakcall_with_pval0.05
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/IDR

#files=$1; shift
#cellline=$1
mkdir -p $OUTDIR
idr --samples ${peaks_dir}/D2300033_D2300036_rep1/D2300033_D2300036_rep1_peaks.sorted.narrowPeak ${peaks_dir}/D2300034_D2300037_rep2/D2300034_D2300037_rep2_peaks.sorted.narrowPeak ${peaks_dir}/D2300035_D2300037_rep3/D2300035_D2300037_rep3_peaks.sorted.narrowPeak \
      --output-file ${OUTDIR}/BT549_idr.bed \
      --plot \
      --rank p.value \
      --log-output-file ${OUTDIR}/BT549_idr.log \
      --verbose

#Column 5 contains the scaled IDR value, min(int(log2(-125IDR), 1000) For example, peaks with an IDR of 0 have a score of 1000, 
#peaks with an IDR of 0.05 have a score of int(-125log2(0.05)) = 540, and IDR of 1.0 has a score of 0.
#select IDR of 0.05
awk '{if($5 >= 540) print $0}' ${OUTDIR}/BT549_idr.bed > ${OUTDIR}/BT549_idr_filtered.bed

#prep file for motif discovery

cut -f 1,2,3 ${OUTDIR}/BT549_idr_filtered.bed > ${OUTDIR}/BT549_idr_filtered_3_columns.bed 




idr --samples ${peaks_dir}/D2300038_D2300041_rep1/D2300038_D2300041_rep1_peaks.sorted.narrowPeak ${peaks_dir}/D2300039_D2300042_rep2/D2300039_D2300042_rep2_peaks.sorted.narrowPeak ${peaks_dir}/D2300040_D2300043_rep3/D2300040_D2300043_rep3_peaks.sorted.narrowPeak \
      --output-file ${OUTDIR}/HCC1806_idr.bed \
      --plot \
      --rank p.value \
      --log-output-file ${OUTDIR}/HCC1806_idr.log \
      --verbose

#Column 5 contains the scaled IDR value, min(int(log2(-125IDR), 1000) For example, peaks with an IDR of 0 have a score of 1000, 
#peaks with an IDR of 0.05 have a score of int(-125log2(0.05)) = 540, and IDR of 1.0 has a score of 0.
#select IDR of 0.05
awk '{if($5 >= 540) print $0}' ${OUTDIR}/HCC1806_idr.bed > ${OUTDIR}/HCC1806_idr_filtered.bed

#prep file for motif discovery

cut -f 1,2,3 ${OUTDIR}/HCC1806_idr_filtered.bed > ${OUTDIR}/HCC1806_idr_filtered_3_columns.bed 



deactivate
