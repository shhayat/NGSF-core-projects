#/datastore/NGSF001/projects/2021/21-1MILE-001/alignment/star
fastq_path=/datastore/NGSF001/projects/2021/21-1MILE-001/fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/Piranha
java -Xmx8G -jar picard.jar FastqToSam \
    FASTQ=$fastq_path/R2100080_S1_R1_001.fastq.gz  \ #first read file of pair
    FASTQ2=$fastq_path/R2100080_S1_R2_001.fastq.gz \ #second read file of pair
    OUTPUT=$OUTDIR/R2100080_fastqtosam.bam
    
