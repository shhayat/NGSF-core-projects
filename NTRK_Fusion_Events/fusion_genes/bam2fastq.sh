#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=bam2fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=185G
#SBATCH --time=24:00:00
#SBATCH --output=%j.out

module load samtools

DATA=/datastore/NGSF001/datasets/canine_datasets/icdc_data/bam
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/icdc_data/analysis/fastq
mkdir -p ${OUTDIR}
sample_name=$1;

#java -Xmx10G -XX:ParallelGCThreads=$NCPU -jar $EBROOTPICARD/picard.jar SamToFastq \
#                                    I=${DATA}/${sample_name}_sorted.bam \
#                                    F=${OUTDIR}/${sample_name}_1.fastq \
#                                    F2=${OUTDIR}${sample_name}_2.fastq
                                    
samtools bam2fq ${DATA}/${sample_name}_sorted.bam  > ${OUTDIR}/${sample_name}.fastq

cat ${OUTDIR}/${sample_name}.fastq | grep '^@.*/1$' -A 3 --no-group-separator > ${OUTDIR}/${sample_name}_1.fastq
cat ${OUTDIR}/${sample_name}.fastq | grep '^@.*/2$' -A 3 --no-group-separator > ${OUTDIR}/${sample_name}_2.fastq

rm ${OUTDIR}/${sample_name}.fastq


