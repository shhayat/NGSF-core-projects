#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=markdup_add_RG
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=2:30:00
#SBATCH --mem=64G
#SBATCH  --output=markdup_add_RG.out
set -eux

#loading required modules
module load picard
module load samtools

#reference file
REF='/datastore/NGSF001/analysis/references/human/gencode-30/GRCh38.primary_assembly.genome.fa'
OUTDIR='/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis'
sample_name=$1
BAM_FILE=$2
NCPU=4
mkdir -p ${OUTDIR}/${sample_name}



#Run MarkDeduplication MarkDuplicates (https://gatk.broadinstitute.org/hc/en-us/articles/4405451219355-MarkDuplicatesSpark)
#Read Group Added
#run these commands from E21000* samples
java -Xmx64G -XX:ParallelGCThreads=$NCPU -jar $EBROOTPICARD/picard.jar MarkDuplicates \
                                    I=${BAM_FILE} \
                                    BARCODE_TAG="RX" \
                                    O=${OUTDIR}/${sample_name}/${sample_name}_markduplicates.bam \
                                    M=${OUTDIR}/${sample_name}/${sample_name}_marked_dup_metrics.txt && \
java -Xmx64G -XX:ParallelGCThreads=$NCPU -jar $EBROOTPICARD/picard.jar AddOrReplaceReadGroups \
                                    I=${OUTDIR}/${sample_name}/${sample_name}_markduplicates.bam \
                                    O=${OUTDIR}/${sample_name}/${sample_name}_mdup_rg.bam \
                                    SO=coordinate \
                                    RGID=4 \
                                    RGLB=lib1 \
                                    RGPL=ILLUMINA \
                                    RGPU=unit1 RGSM=20

samtools index ${OUTDIR}/${sample_name}/${sample_name}_mdup_rg.bam
