#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=denovo
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --time=240:00:00
#SBATCH --mem=200G
#SBATCH --output=/project/anderson/%j.out

source /globalhome/hxo752/HPC/.bashrc

#module load perl/5.36.1
#module load python/3.10.13
#module load fastqc/0.12.1
#module load trimmomatic/0.39
#module load bowtie2/2.5.2
#module load blast/2.2.26  
#module load prodigal/2.6.3
module load bbmap/39.06  

sample_name=$1; shift
paired_fq1=$1; shift
paired_fq2=$1; shift
unpaired_fq1=$1; shift
unpaired_fq2=$1;

NCPU=30
Gen2Epi_Scripts=/globalhome/hxo752/HPC/tools/Gen2Epi/Gen2Epi_Scripts
FASTQ_DIR=/project/anderson/trimmed_fastq_v1
OUTDIR=/project/anderson/denovo_assembly
mkdir -p $OUTDIR/Chrom_AssemblyTrimmedReads
mkdir -p $OUTDIR/Plasmid_AssemblyTrimmedReads
mkdir -p $OUTDIR/ChromContigAssemblyTrimmedStat
mkdir -p $OUTDIR/PlasmidContigAssemblytrimmedStat
#create sample sheet for fastq files
#python /project/anderson/sample_prep.py > /project/anderson/denovo_assembly/Prepare_Input.txt
#denovo assembly
#perl ${Gen2Epi_Scripts}/WGS_SIBP_P2.pl /project/anderson/denovo_assembly/Prepare_Input.txt ${FASTQ_DIR} trimmed ${NCPU}

spades.py --pe1-1 $paired_fq1 \
          --pe1-2 $paired_fq2 \  
          --pe1-s $unpaired_fq1 \
          --pe1-s $unpaired_fq2 \
          --cov-cutoff auto \
          --careful \
          --threads $NCPU \
          -o $$OUTDIR/Chrom_AssemblyTrimmedReads/${sample_name}_


plasmidspades.py --pe1-1 $paired_fq1 \
--pe1-2 $paired_fq2 \
--pe1-s $unpaired_fq1 \
--pe1-s $unpaired_fq2 \
--cov-cutoff auto \
--careful \
--threads $NCPU \
-o $$OUTDIR/Plasmid_AssemblyTrimmedReads/${sample_name}_



