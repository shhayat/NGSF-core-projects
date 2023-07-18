#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=QC-deeptools
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=6:00:00
#SBATCH --mem=80G
#SBATCH  --output=%j.out

#deeptools
#cd /globalhome/hxo752/HPC/.local/lib/python3.7/site-packages/deeptools/
cd /globalhome/hxo752/HPC/anaconda3/envs/deeptools/bin
NCPUS=4
DIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis"
bam_files=$1; shift
labels=$1; shift
cellline=$1;

mkdir -p ${DIR}/QC/deeptools/${cellline}

#cumulative enrichment
plotFingerprint \
            --bamfiles ${bam_files} \
            --minMappingQuality 30 \
            --binSize=1000 \
            --skipZeros \
            --plotFile ${DIR}/QC/deeptools/${cellline}/fingerprint.pdf \
            --labels ${labels} \
            -p ${NCPUS} &> ${DIR}/QC/deeptools/${cellline}/fingerprint.log

#read coverages for genomic regions for the BAM files
multiBamSummary bins \
           --bamfiles ${bam_files} \
           --outFileName ${DIR}/QC/deeptools/${cellline}/bamCorrelate_coverage.npz \
           --binSize=5000 \
           --labels ${labels} \
           -p ${NCPUS} &> ${DIR}/QC/deeptools/${cellline}/multiBamSummary.log

#PCA for read coverage
plotPCA \
            --corData ${DIR}/QC/deeptools/${cellline}/bamCorrelate_coverage.npz \
            --plotFile ${DIR}/QC/deeptools/${cellline}/pca.pdf \
            --labels ${labels}
