#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=denovo
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --time=24:00:00
#SBATCH --mem=200G
#SBATCH --output=/project/anderson/%j.out


module load bbmap/39.06  

sample_name=$1; shift
paired_fq1=$1; shift
paired_fq2=$1; shift
unpaired_fq1=$1; shift
unpaired_fq2=$1;

NCPU=10
spades_tool=/globalhome/hxo752/HPC/tools/spades-4.0.0/bin
OUTDIR=/project/anderson/denovo_assembly

mkdir -p ${OUTDIR}/Chrom_AssemblyTrimmedReads
mkdir -p ${OUTDIR}/ChromContigAssemblyTrimmedStat

mkdir -p ${OUTDIR}/Chrom_AssemblyTrimmedReads/${sample_name}

#create sample sheet for fastq files
#python /project/anderson/sample_prep.py > /project/anderson/denovo_assembly/Prepare_Input.txt
#denovo assembly
#perl ${Gen2Epi_Scripts}/WGS_SIBP_P2.pl /project/anderson/denovo_assembly/Prepare_Input.txt ${FASTQ_DIR} trimmed ${NCPU}

cd ${OUTDIR}/Chrom_AssemblyTrimmedReads/${sample_name}
${spades_tool}/spades.py \
-1 ${paired_fq1} \
-2 ${paired_fq2} \
--pe-s 1 ${unpaired_fq1} \
--pe-s 2 ${unpaired_fq2} \
--cov-cutoff auto \
--careful \
--threads ${NCPU} \
-o ${OUTDIR}/Chrom_AssemblyTrimmedReads/${sample_name}

stats.sh in=${OUTDIR}/Chrom_AssemblyTrimmedReads/${sample_name}/contigs.fasta \
         gchist=${OUTDIR}/ChromContigAssemblyTrimmedStat/${sample_name}_GC_hist \
         shist=${OUTDIR}/ChromContigAssemblyTrimmedStat/${sample_name}_length_hist > ${OUTDIR}/ChromContigAssemblyTrimmedStat/${sample_name}_Assembly_Stat
