DATA=/datastore/NGSF001/datasets/chipseq_mouse

for fq in $DATA/SRR*/*.fastq
do
   sbatch 01_FastQC.sh "${fq}"
   sleep 0.2
done 
