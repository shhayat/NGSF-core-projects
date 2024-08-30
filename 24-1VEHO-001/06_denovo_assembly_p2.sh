#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=denovo
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --time=24:00:00
#SBATCH --mem=40G
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

mkdir -p ${OUTDIR}/Plasmid_AssemblyTrimmedReads
mkdir -p ${OUTDIR}/PlasmidContigAssemblytrimmedStat
mkdir -p ${OUTDIR}/Plasmid_AssemblyTrimmedReads/${sample_name}


cd ${OUTDIR}/Plasmid_AssemblyTrimmedReads/${sample_name}
${spades_tool}/plasmidspades.py \
-1 ${paired_fq1} \
-2 ${paired_fq2} \
--pe-s 1 ${unpaired_fq1} \
--pe-s 2 ${unpaired_fq2} \
--cov-cutoff auto \
--careful \
--threads ${NCPU} \
-o ${OUTDIR}/Plasmid_AssemblyTrimmedReads/${sample_name}

stats.sh in=${OUTDIR}/Plasmid_AssemblyTrimmedReads/${sample_name}/contigs.fasta \
         gchist=${OUTDIR}/PlasmidContigAssemblytrimmedStat/${sample_name}_GC_hist \
         shist=${OUTDIR}/PlasmidContigAssemblytrimmedStat/${sample_name}_length_hist > ${OUTDIR}/PlasmidContigAssemblytrimmedStat/${sample_name}_Assembly_Stat


