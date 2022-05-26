
#!/bin/bash

#SBATCH --job-name=star-align
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=1:25:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

#loading required modules
module load star/2.7.9a 
module load samtools

DATA=
GENOME=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001/indices/gencode-40
GTF=
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/new_proj/star_alignment
NCPU=4

rsync -avzP /datastore/NGSF001/analysis/references/human/gencode-40/gencode.v40.annotation.gtf ${SLURM_TMPDIR}/

mkdir -p ${OUTDIR}
sample_name=1; shift
R1=2; shift
R2=3

STAR --genomeDir $GENOME \
	--readFilesCommand zcat \
	--readFilesIn $R1 $R2 \
	--sjdbGTFfile $GTF \
	--outSAMstrandField intronMotif \
	--outSAMtype BAM SortedByCoordinate \
	--outFilterIntronMotifs RemoveNoncanonical \
	--runThreadN $NCPU \
	&& samtools index $OUTDATA/STAR_alignment/${OUTDIR}/${sample_name}_star/Aligned.sortedByCoord.out.bam 
