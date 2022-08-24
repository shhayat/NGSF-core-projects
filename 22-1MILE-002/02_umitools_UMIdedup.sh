




module load samtools
umi_tools=/globalhome/hxo752/HPC/anaconda3/bin
RRNA=/datastore/NGSF001/analysis/references/rat/Rnor_6.0/ncbi-genomes-2020-10-30/GCF_000001895.5_Rnor_6.0/rRNA_intervals.bed

NCPU=$SLURM_CPUS_PER_TASK

DIR=
sample_name=
bam=

mkdir -p ${DIR}/deduplication/{sample_name} && cd ${DIR}/deduplication/{sample_name}
echo "Dropping ribosomal RNA reads"
samtools view -@ ${NCPU} -U {sample_name}.no-rRNA.bam -O BAM -L ${RRNA} ${bam}




