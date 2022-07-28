#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=QC-deeptools
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module load python/3.7.7
#deeptools
cd /globalhome/hxo752/HPC/.local/lib/python3.7/site-packages/deeptools/

NCPUS=8
DIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis"
bam_files=$1; shift
labels=$1;
mkdir -p ${DIR}/QC/deeptools

#cumulative enrichment
python plotFingerprint.py \
            --bamfiles ${bam_files} \
            --minMappingQuality 30 \
            --binSize=1000 \
            --skipZeros \
            --plotFile ${DIR}/QC/deeptools/fingerprint.pdf \
            --labels ${labels} \
            -p ${NCPUS} &> ${DIR}/QC/deeptools/fingerprint.log

#read coverages for genomic regions for the BAM files
python multiBamSummary.py bins \
           --bamfiles ${bam_files} \
           --outFileName ${DIR}/QC/deeptools/bamCorrelate_coverage.npz \
           --binSize=5000 \
           --labels ${labels} \
           -p ${NCPUS} &> ${DIR}/QC/deeptools/multiBamSummary.log

#sample clustering code runs but no output is generated
#python plotCorrelation.py \
#            --corData ${DIR}/QC/deeptools/bamCorrelate_coverage.npz \
#            --plotFile ${DIR}/QC/deeptools/sample_clustering_heatmap.pdf \
#            --outFileCorMatrix ${DIR}/QC/deeptools/corr_matrix_bin.txt \
#            --whatToPlot heatmap \
#            --corMethod spearman
       
#PCA for read coverage
python plotPCA.py \
            --corData ${DIR}/QC/deeptools/bamCorrelate_coverage.npz \
            --plotFile ${DIR}/QC/deeptools/pca.pdf \
            --labels ${labels}   
        
module unload python/3.7.7
