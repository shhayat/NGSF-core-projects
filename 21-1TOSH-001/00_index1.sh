#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --time=24:00:00
#SBATCH --mem=375G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module load star/2.7.9a 


GENOME=/datastore/NGSF001/analysis/references/bison/ftp.ensembl.org/pub/release-109/fasta
GTF=/datastore/NGSF001/analysis/references/bison/ftp.ensembl.org/pub/release-109/gtf/Bison_bison_bison.Bison_UMD1.0.109.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001/analysis/indices

NCPU=10

mkdir -p $OUTDIR
cd ${OUTDIR}

STAR --runThreadN ${NCPU} \
     --runMode genomeGenerate \
     --genomeDir star-index \
     --limitGenomeGenerateRAM 375000000000 \
     --genomeFastaFiles ${GENOME}/Bison_bison_bison.Bison_UMD1.0.dna.toplevel.fa \
     --sjdbGTFfile ${GTF} \
     --sjdbOverhang 99
