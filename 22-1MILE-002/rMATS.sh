
#there was environment problem while installing rmats with conda. 
#For fixing this issue conda env "rMATS" was created 
#./globalhome/hxo752/HPC/anaconda3/condabin/conda create -n rMATS -c bioconda rMATS then go to path /globalhome/hxo752/HPC/anaconda3/envs/rMATS/bin and run commands

rmat=/globalhome/hxo752/HPC/anaconda3/envs/rMATS/bin
DATA=
GTF=/datastore/NGSF001/analysis/references/rat/Rnor_6.0/ncbi-genomes-2020-10-30/GCF_000001895.5_Rnor_6.0/GCF_000001895.5_Rnor_6.0_genomic.gtf
NCPU=4

python rmats.py --s1 /path/to/s1.txt \
                --s2 /path/to/s2.txt \
                --gtf /path/to/the.gtf \
                --bi /path/to/STAR_binary_index \
                -t paired \
                --readLength 50 \
                --nthread $NCPU \
                --od /path/to/output \
                --tmp /path/to/tmp_output
