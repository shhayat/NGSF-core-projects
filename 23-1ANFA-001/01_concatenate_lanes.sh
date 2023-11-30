ngsf1=/datastore/NGSF001/NB551711/230927_NB551711_0084_AH2FGFBGXV/Alignment_1/20230928_022021/Fastq
ngsf2=/datastore/NGSF001/NB551711/230928_NB551711_0085_AH2KFHBGXV/Alignment_1/20230929_024416/Fastq

opal1=/datastore/NGSF001/projects/23-1ANFA-001/data/Sequencing results downloaded from OPAL/23-1ANFA-001-OPAL/samples lane 1
opal2=/datastore/NGSF001/projects/23-1ANFA-001/data/Sequencing results downloaded from OPAL/23-1ANFA-001-OPAL/samples lane 2

OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANFA-001/analysis/fastq

mkdir -p $OUTDIR

for i in 15 16 17 18
do

	cat ${ngsf1}/SC23000${i}_S1_*_R1_001.fastq.gz ${ngsf2}/SC23000${i}_S1_*_R1_001.fastq.gz > ${OUTDIR}/SC23000${i}_R1.fastq.gz
	cat ${ngsf1}/SC23000${i}_S1_*_R2_001.fastq.gz ${ngsf2}/SC23000${i}_S1_*_R2_001.fastq.gz > ${OUTDIR}/SC23000${i}_R2.fastq.gz
done


