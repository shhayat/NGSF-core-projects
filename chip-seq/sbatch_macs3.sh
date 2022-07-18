#!/bin/sh

while read control treat sample_name; 
do
    sbatch 04_MACS3.sh "$control" "$treat" "$sample_name";
    sleep 0.3
done < 'samples.txt'
