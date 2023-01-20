#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=10
#SBATCH --time=03:00:00
#SBATCH --mem=80G
#SBATCH --output=%j.out

#activate the virtual environment created for running cell ranger, check installation_issues.txt for detail 
#source /globalhome/hxo752/HPC/cell_ranger_env/bin/activate
#module load python/3.9
export PATH=/globalhome/hxo752/HPC/tools/cellranger-7.1.0/bin:$PATH
#export PYTHONHOME=/cvmfs/soft.computecanada.ca/easybuild/software/2020/avx/Core/python/3.9.6/bin/python:$PYTHONHOME
#export PATH=/globalhome/hxo752/HPC/.local/lib/python3.9/site-packages/docopt-0.6.2+computecanada.dist-info:$PATH
GENOME=/datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa
GTF=/datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Annotation/Genes/genes.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/analysis/indices

NCPU=10

mkdir -p $OUTDIR
cd ${OUTDIR}

cellranger mkref \
         --nthreads=${NCPUS} \
         --genome=${OUTDIR} \
         --fasta=${GENOME} \
         --genes=${GTF}
