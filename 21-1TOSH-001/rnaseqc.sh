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

GTF=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001/bison.liftoff.chromosomes.gtf
OUTDATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001/STAR_alignment

${SLURM_TMPDIR}/rnaseqc.v2.4.2.linux ${GTF} \
                        ${OUTDATA}/R2200001_star/star_Aligned.sortedByCoord.out.bam \
                        --sample="R2200001" \
                        ${OUTDATA}
