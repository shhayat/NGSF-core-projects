#!/bin/sh

while read control treat sample_name; 
do
    sbatch 06_MACS2.sh "$control" "$treat" "$sample_name";
    sleep 0.3
done < 'samples_for_mac2.txt'
