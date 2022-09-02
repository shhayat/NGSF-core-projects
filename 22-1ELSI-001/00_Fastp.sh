#!/bin/bash

# run fastp to trim adapters and low-quality sequences from reads
# usage run-fastp.sh file-of-files.txt
# file-of-files (fof) has R1 and R2 on single line separated by a space

#SBATCH --job-name=RNA_trim
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=01:00:00
#SBATCH --mem=8G
#SBATCH --account=hpc_p_anderson
set -eux


THREADS=4
infile=$1

module load fastp/0.20.1

while read line; do
    file1=$(echo $line | awk '{print $1}')
    fname1=$(echo $file1 | awk -F\/ '{print $NF}')
    bname1=$(echo $fname1 | sed 's/.fastq.gz//')
    file2=$(echo $line | awk '{print $2}')
    fname2=$(echo $file2 | awk -F\/ '{print $NF}')
    bname2=$(echo $fname2 | sed 's/.fastq.gz//')
    corename=$(echo $bname1 | awk -F'_' '{print$1}')
    # corename=$(echo $bname1 | sed 's/_R1//')

    mkdir ${corename}

    fastp --in1 $file1 --in2 $file2 \
        --out1 ${corename}/${bname1}_trimmed.fastq.gz --out2 ${corename}/${bname2}_trimmed.fastq.gz \
        --unpaired1 ${corename}/${bname1}_trimmed_unpaired.fastq.gz \
        --unpaired2 ${corename}/${bname2}_trimmed_unpaired.fastq.gz \
        -V \
        -l 30 \
        -p \
        -w $THREADS \
        -j ${corename}/${corename}.fastp.json \
        -h ${corename}/${corename}.fastp.html \
        -e 10 \
        -q 10 \
        -M 10 \
        -r \
        -W 6 \
        -g
done < $infile
