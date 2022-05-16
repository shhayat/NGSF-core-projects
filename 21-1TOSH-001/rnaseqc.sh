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

GTF=/datastore/NGSF001/analysis/references/bison/jhered/esab003/bison.liftoff.chromosomes.gff
OUTDATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001/STAR_alignment


#sort the provided bam file
# samtools sort -@4 -m4G -O BAM /datastore/NGSF001/projects/21-1MILE-005/alignment/minimap2/${name}.all-transcripts.mm10.sam > ${name}_mm10.pos-sorted.bam

# run help because I can
# ${SLURM_TMPDIR}/rnaseqc.v2.4.2.linux -h


${SLURM_TMPDIR}/rnaseqc.v2.4.2.linux ${GTF} \
                        ${OUTDATA}/R2200001_star/star_Aligned.sortedByCoord.out.bam \
                        --sample="R2200001" \
                        output ${OUTDATA}
