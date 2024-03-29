#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=picard
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=3:00:00
#SBATCH --mem=80G
#SBATCH  --output=%j.out

set -eux

#module load picard/2.23.3 
module load samtools
#module load nixpkgs/16.09
#module load picard
#module load gcc/5.4.0
#module load intel/2016.4
module load sambamba
#module load bedtools/2.26.0
module load bedtools
BAMDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/alignment
NCPU=4

sample_name=$1

#java -Xmx80G -XX:ParallelGCThreads=$NCPU -Djava.io.tmpdir=$SLURM_TMPDIR -jar $EBROOTPICARD/picard.jar AddOrReplaceReadGroups \
#	I=${BAMDIR}/${sample_name}/${sample_name}.aligned.bam \
#	O=${BAMDIR}/${sample_name}/${sample_name}.aligned_sort.bam \
#	SO=coordinate \
#	RGID=4 \
#	RGLB=lib1 \
#	RGPL=ILLUMINA \
#	RGPU=unit1 \
#	RGSM=20

#java -Xmx80G -XX:ParallelGCThreads=$NCPU -Djava.io.tmpdir=$SLURM_TMPDIR -jar $EBROOTPICARD/picard.jar MarkDuplicates \
 #           I=${BAMDIR}/${sample_name}/${sample_name}.aligned_sort.bam \
  #          O=${BAMDIR}/${sample_name}/${sample_name}.aligned_dedup.bam \
   #         M=${BAMDIR}/${sample_name}/dedup_metrics.txt \
    #	    VALIDATION_STRINGENCY=LENIENT \
     #	    REMOVE_DUPLICATES=true \
      #	    ASSUME_SORTED=true 2> ${BAMDIR}/${sample_name}/${sample_name}_picard.log && \
	#    samtools index ${BAMDIR}/${sample_name}/${sample_name}.aligned_dedup.bam

 #remove unmapped , multimapped and duplicated reads
#https://hbctraining.github.io/Intro-to-ChIPseq-flipped/lessons/05_filtering_BAM_files.html
sambamba view -h -t 2 -f bam -F "[XS] == null and not unmapped and not duplicate" \
           ${BAMDIR}/${sample_name}/${sample_name}.aligned_sort.bam > ${BAMDIR}/${sample_name}/${sample_name}.aligned_dedup.bam && \
	   samtools index ${BAMDIR}/${sample_name}/${sample_name}.aligned_dedup.bam

#Remove reads from *.aligned_dedup.bam which are present in blacklist
bedtools intersect -v -a ${BAMDIR}/${sample_name}/${sample_name}.aligned_dedup.bam \
		      -b /datastore/NGSF001/projects/23-1DEAN-001/analysis/hg38-blacklist.v2.bed > ${BAMDIR}/${sample_name}/${sample_name}.aligned_dedup_filt.bam

#sort bam files
samtools sort -T $SLURM_TMPDIR \
	      -o ${BAMDIR}/${sample_name}/${sample_name}.aligned_dedup_filt_sort.bam \
	      ${BAMDIR}/${sample_name}/${sample_name}.aligned_dedup_filt.bam && \
	      samtools index ${BAMDIR}/${sample_name}/${sample_name}.aligned_dedup_filt_sort.bam

