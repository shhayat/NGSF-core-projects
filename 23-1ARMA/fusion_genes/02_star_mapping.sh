#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=star-align
#SBATCH --ntasks=1
#BATCH --cpus-per-task=4
#SBATCH --time=03:00:00
#SBATCH --mem=40G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

#activate star-fusion to use STAR version 2.7.10b
source /globalhome/hxo752/HPC/.bashrc
conda activate star-fusion

DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/fastq
GENOME=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/indices
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/star_alignment
NCPU=4

sample_name=$1; shift
fq1=$1; shift
fq2=$1

mkdir -p ${OUTDIR}/${sample_name} && cd ${OUTDIR}/${sample_name}

STAR --genomeDir $GENOME \
	--readFilesCommand zcat \
	--readFilesIn ${fq1} ${fq2} \
	--outReadsUnmapped None \
        --twopassMode Basic \
	--runThreadN ${NCPU} \
	--outSAMstrandField intronMotif \
        --outSAMunmapped Within \
        --chimSegmentMin 12 \  # ** essential to invoke chimeric read detection & reporting **
        --chimJunctionOverhangMin 8 \
        --chimOutJunctionFormat 1 \   # **essential** includes required metadata in Chimeric.junction.out file.
        --alignSJDBoverhangMin 10 \
        --alignMatesGapMax 100000 \   # avoid readthru fusions within 100k
        --alignIntronMax 100000 \
        --alignSJstitchMismatchNmax 5 -1 5 5 \   # settings improved certain chimera detections
        --outSAMattrRGline ID:GRPundef \
        --chimMultimapScoreRange 3 \
        --chimScoreJunctionNonGTAG -4 \
        --chimMultimapNmax 20 \
        --chimNonchimScoreDropMin 10 \
        --peOverlapNbasesMin 12 \
        --peOverlapMMp 0.1 \
        --alignInsertionFlush Right \
        --alignSplicedMateMapLminOverLmate 0 \
        --alignSplicedMateMapLmin 30
	
conda deactivate
