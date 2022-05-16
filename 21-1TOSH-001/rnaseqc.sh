#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=00:20:00
#SBATCH --mem=10G

set -eux

# module load gcc/9.3.0
# module load samtools/1.13

# move binary to tempdir and give execute permission
cp /datastore/NGSF001/software/src/rnaseqc.v2.4.2.linux ${SLURM_TMPDIR}
chmod u+x ${SLURM_TMPDIR}/rnaseqc.v2.4.2.linux

name=$1; shift
bam=$1
gtf=/datastore/NGSF001/analysis/references/rat/Rnor_6.0/ncbi-genomes-2020-10-30/GCF_000001895.5_Rnor_6.0/GCF_000001895.5_Rnor_6.0_genomic.gtf

#sort the provided bam file
# samtools sort -@4 -m4G -O BAM /datastore/NGSF001/projects/21-1MILE-005/alignment/minimap2/${name}.all-transcripts.mm10.sam > ${name}_mm10.pos-sorted.bam

# run help because I can
# ${SLURM_TMPDIR}/rnaseqc.v2.4.2.linux -h


${SLURM_TMPDIR}/rnaseqc.v2.4.2.linux ${gtf} \
                        ${bam} \
                        ${SLURM_SUBMIT_DIR} \
                        --sample=${name}
