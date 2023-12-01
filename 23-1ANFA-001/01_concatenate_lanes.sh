#!/bin/bash
	
#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=6:00:00
#SBATCH --mem=8G
#SBATCH --account=hpc_p_anderson

ngsf1=/datastore/NGSF001/NB551711/230927_NB551711_0084_AH2FGFBGXV/Alignment_1/20230928_022021/Fastq
ngsf2=/datastore/NGSF001/NB551711/230928_NB551711_0085_AH2KFHBGXV/Alignment_1/20230929_024416/Fastq

opal1=/datastore/NGSF001/projects/23-1ANFA-001/data/Sequencing_results_downloaded_from_OPAL/23-1ANFA-001-OPAL/samples_lane_1
opal2=/datastore/NGSF001/projects/23-1ANFA-001/data/Sequencing_results_downloaded_from_OPAL/23-1ANFA-001-OPAL/samples_lane_2

OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANFA-001/analysis/fastq_concatenated

mkdir -p $OUTDIR

for i in 15 16 17 18
do

	cat ${ngsf1}/SC23000${i}_*_R1_001.fastq.gz ${ngsf2}/SC23000${i}_*_R1_001.fastq.gz > ${OUTDIR}/SC23000${i}_R1.fastq.gz
	cat ${ngsf1}/SC23000${i}_*_R2_001.fastq.gz ${ngsf2}/SC23000${i}_*_R2_001.fastq.gz > ${OUTDIR}/SC23000${i}_R2.fastq.gz
done

#cat ${opal1}/OS010364_r1.fastq.gz ${opal2}/OS01036A_r1.fastq.gz > ${OUTDIR}/SC2300009_R1.fastq.gz
#cat ${opal1}/OS010365_r1.fastq.gz ${opal2}/OS01036B_r1.fastq.gz > ${OUTDIR}/SC2300010_R1.fastq.gz
#cat ${opal1}/OS010366_r1.fastq.gz ${opal2}/OS01036C_r1.fastq.gz > ${OUTDIR}/SC2300011_R1.fastq.gz
#cat ${opal1}/OS010367_r1.fastq.gz ${opal2}/OS01036D_r1.fastq.gz > ${OUTDIR}/SC2300012_R1.fastq.gz
#cat ${opal1}/OS010368_r1.fastq.gz ${opal2}/OS01036E_r1.fastq.gz > ${OUTDIR}/SC2300013_R1.fastq.gz
#cat ${opal1}/OS010369_r1.fastq.gz ${opal2}/OS01036F_r1.fastq.gz > ${OUTDIR}/SC2300014_R1.fastq.gz


#cat ${opal1}/OS010364_r2.fastq.gz ${opal2}/OS01036A_r2.fastq.gz > ${OUTDIR}/SC2300009_R2.fastq.gz
#cat ${opal1}/OS010365_r2.fastq.gz ${opal2}/OS01036B_r2.fastq.gz > ${OUTDIR}/SC2300010_R2.fastq.gz
#cat ${opal1}/OS010366_r2.fastq.gz ${opal2}/OS01036C_r2.fastq.gz > ${OUTDIR}/SC2300011_R2.fastq.gz
#cat ${opal1}/OS010367_r2.fastq.gz ${opal2}/OS01036D_r2.fastq.gz > ${OUTDIR}/SC2300012_R2.fastq.gz
#cat ${opal1}/OS010368_r2.fastq.gz ${opal2}/OS01036E_r2.fastq.gz > ${OUTDIR}/SC2300013_R2.fastq.gz
#cat ${opal1}/OS010369_r2.fastq.gz ${opal2}/OS01036F_r2.fastq.gz > ${OUTDIR}/SC2300014_R2.fastq.gz


