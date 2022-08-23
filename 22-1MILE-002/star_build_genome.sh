#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=ivybridge
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=16
#SBATCH --time=03:00:00
#SBATCH --mem=30G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

NCPU=10

OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-002/indices
star=/datastore/NGSF001/software/tools/STAR-2.7.4a/bin/Linux_x86_64
mkdir -p ${SLURM_TMPDIR}/Rnor_6.0
mkdir -p ${OUTDIR}

#STAR-2.7.4a
${star}/STAR --runThreadN ${NCPU} \
     --runMode genomeGenerate \
     --genomeDir star-index \
     --genomeFastaFiles /datastore/NGSF001/analysis/references/rat/Rnor_6.0/ncbi-genomes-2020-10-30/GCF_000001895.5_Rnor_6.0/GCF_000001895.5_Rnor_6.0_genomic.fa \
     --sjdbGTFfile /datastore/NGSF001/analysis/references/rat/Rnor_6.0/ncbi-genomes-2020-10-30/GCF_000001895.5_Rnor_6.0/GCF_000001895.5_Rnor_6.0_genomic.gtf \
     --sjdbOverhang 99

rsync -rvzP ${SLURM_TMPDIR}/Rnor_6.0 ${OUTDIR}
